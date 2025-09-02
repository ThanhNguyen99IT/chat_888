const db = require('../config/db');
const crypto = require('crypto');
const multer = require('multer');
const path = require('path');

// Tạo token ngẫu nhiên
const generateToken = () => {
  return crypto.randomBytes(32).toString('hex');
};

// Cấu hình multer cho upload ảnh
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    // Tạo tên file unique: timestamp_randomstring.extension
    const uniqueSuffix = Date.now() + '_' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const fileFilter = (req, file, cb) => {
  console.log('📄 File info:', {
    fieldname: file.fieldname,
    originalname: file.originalname,
    mimetype: file.mimetype,
    size: file.size
  });
  
  // Chỉ cho phép file ảnh - thêm nhiều MIME types và extension check
  const allowedMimeTypes = [
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/gif',
    'image/webp',
    'image/bmp',
    'image/svg+xml'
  ];
  
  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg'];
  const fileExtension = path.extname(file.originalname).toLowerCase();
  
  if (allowedMimeTypes.includes(file.mimetype) || allowedExtensions.includes(fileExtension)) {
    console.log('✅ File accepted:', file.originalname);
    cb(null, true);
  } else {
    console.log('❌ File rejected:', file.mimetype, fileExtension);
    const error = new Error('Chỉ được upload file ảnh (jpg, png, gif, webp, bmp, svg)!');
    error.code = 'INVALID_FILE_TYPE';
    cb(error, false);
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB
  }
});

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

    // Tạo token ngẫu nhiên
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

    const query = 'SELECT id, name, phone, token, image_url, created_at FROM users WHERE token = $1';
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

// Middleware xử lý lỗi multer
exports.handleMulterError = (err, req, res, next) => {
  if (err) {
    if (err.code === 'INVALID_FILE_TYPE') {
      return res.status(400).json({
        status: 'error',
        message: 'Chỉ được upload file ảnh (jpg, png, gif, etc.)',
        data: {}
      });
    }
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        status: 'error',
        message: 'File quá lớn. Tối đa 5MB',
        data: {}
      });
    }
    return res.status(400).json({
      status: 'error',
      message: err.message || 'Lỗi upload file',
      data: {}
    });
  }
  next();
};

// Upload ảnh đại diện
exports.uploadAvatar = async (req, res) => {
  try {
    const { token } = req.headers;

    if (!token) {
      return res.status(401).json({
        status: 'error',
        message: 'Vui lòng cung cấp token xác thực',
        data: {}
      });
    }

    if (!req.file) {
      return res.status(400).json({
        status: 'error',
        message: 'Vui lòng chọn file ảnh',
        data: {}
      });
    }

    // Kiểm tra user tồn tại
    const userQuery = 'SELECT id FROM users WHERE token = $1';
    const userResult = await db.query(userQuery, [token]);

    if (userResult.rows.length === 0) {
      return res.status(401).json({
        status: 'error',
        message: 'Token không hợp lệ',
        data: {}
      });
    }

    const userId = userResult.rows[0].id;
    const imageUrl = `/uploads/${req.file.filename}`;

    // Cập nhật image_url trong database
    const updateQuery = 'UPDATE users SET image_url = $1 WHERE id = $2 RETURNING id, name, phone, image_url';
    const updateResult = await db.query(updateQuery, [imageUrl, userId]);

    return res.json({
      status: 'success',
      message: 'Upload ảnh đại diện thành công',
      data: {
        user: updateResult.rows[0],
        imageUrl: imageUrl
      }
    });

  } catch (error) {
    console.error('Lỗi upload ảnh:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Lỗi máy chủ, vui lòng thử lại',
      data: {}
    });
  }
};

// Export multer upload middleware
exports.uploadMiddleware = upload.single('avatar');
