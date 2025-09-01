const db = require('../config/db');
const crypto = require('crypto');

// Tạo token ngẫu nhiên
const generateToken = () => {
  return crypto.randomBytes(32).toString('hex');
};

// Đăng ký
exports.register = async (req, res) => {
  try {
    const { name, phone, password } = req.body;

    // Validate input
    if (!name || !phone || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Vui lòng điền đầy đủ thông tin (tên, số điện thoại, mật khẩu)',
        data: {}
      });
    }

    // Kiểm tra số điện thoại đã tồn tại
    const existingUser = await db.query('SELECT id FROM users WHERE phone = $1', [phone]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({
        status: 'error',
        message: 'Số điện thoại đã được đăng ký',
        data: {}
      });
    }

    // Tạo token mới
    const token = generateToken();

    // Thêm user mới vào database
    const query = `
      INSERT INTO users (name, phone, password, token)
      VALUES ($1, $2, $3, $4)
      RETURNING id, name, phone, token, created_at
    `;
    const result = await db.query(query, [name, phone, password, token]);

    return res.status(201).json({
      status: 'success',
      message: 'Đăng ký thành công',
      data: {
        user: result.rows[0]
      }
    });

  } catch (error) {
    console.error('Lỗi đăng ký:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Lỗi máy chủ, vui lòng thử lại',
      data: {}
    });
  }
};

// Đăng nhập
exports.login = async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Validate input
    if (!phone || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Vui lòng nhập số điện thoại và mật khẩu',
        data: {}
      });
    }

    // Tìm user theo số điện thoại
    const query = 'SELECT * FROM users WHERE phone = $1';
    const result = await db.query(query, [phone]);

    if (result.rows.length === 0) {
      return res.status(401).json({
        status: 'error',
        message: 'Số điện thoại không tồn tại',
        data: {}
      });
    }

    const user = result.rows[0];

    // Kiểm tra mật khẩu (trong thực tế nên dùng bcrypt)
    if (user.password !== password) {
      return res.status(401).json({
        status: 'error',
        message: 'Mật khẩu không đúng',
        data: {}
      });
    }

    // Tạo token mới nếu chưa có
    let token = user.token;
    if (!token) {
      token = generateToken();
      await db.query('UPDATE users SET token = $1 WHERE id = $2', [token, user.id]);
    }

    // Trả về thông tin user (không bao gồm mật khẩu)
    const userResponse = {
      id: user.id,
      name: user.name,
      phone: user.phone,
      token: token,
      created_at: user.created_at
    };

    return res.json({
      status: 'success',
      message: 'Đăng nhập thành công',
      data: {
        user: userResponse
      }
    });

  } catch (error) {
    console.error('Lỗi đăng nhập:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Lỗi máy chủ, vui lòng thử lại',
      data: {}
    });
  }
};

// Lấy thông tin user từ token
exports.getProfile = async (req, res) => {
  try {
    const { token } = req.headers;

    if (!token) {
      return res.status(401).json({
        status: 'error',
        message: 'Vui lòng cung cấp token xác thực',
        data: {}
      });
    }

    const query = 'SELECT id, name, phone, token, created_at FROM users WHERE token = $1';
    const result = await db.query(query, [token]);

    if (result.rows.length === 0) {
      return res.status(401).json({
        status: 'error',
        message: 'Token không hợp lệ',
        data: {}
      });
    }

    return res.json({
      status: 'success',
      message: 'Lấy thông tin thành công',
      data: {
        user: result.rows[0]
      }
    });

  } catch (error) {
    console.error('Lỗi lấy thông tin:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Lỗi máy chủ, vui lòng thử lại',
      data: {}
    });
  }
};
