const db = require('../config/db');

exports.list = async (req, res) => {
  try {
    const { rows } = await db.query('SELECT * FROM memories ORDER BY created_at DESC');
    return res.json({ status: 'success', message: 'Lấy danh sách thành công', data: rows });
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Lỗi máy chủ', data: {} });
  }
};

exports.create = async (req, res) => {
  try {
    const { title, content } = req.body;
    const q = 'INSERT INTO memories(title, content) VALUES($1,$2) RETURNING *';
    const { rows } = await db.query(q, [title, content]);
    return res.status(201).json({ status: 'success', message: 'Tạo bản ghi thành công', data: rows[0] });
  } catch (e) {
    return res.status(400).json({ status: 'error', message: 'Dữ liệu không hợp lệ', data: {} });
  }
};

exports.detail = async (req, res) => {
  try {
    const { id } = req.params;
    const { rows } = await db.query('SELECT * FROM memories WHERE id=$1', [id]);
    if (!rows[0]) return res.status(404).json({ status: 'error', message: 'Không tìm thấy', data: {} });
    return res.json({ status: 'success', message: 'Thành công', data: rows[0] });
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Lỗi máy chủ', data: {} });
  }
};

exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, content } = req.body;
    const q = 'UPDATE memories SET title=$1, content=$2 WHERE id=$3 RETURNING *';
    const { rows } = await db.query(q, [title, content, id]);
    if (!rows[0]) return res.status(404).json({ status: 'error', message: 'Không tìm thấy', data: {} });
    return res.json({ status: 'success', message: 'Cập nhật thành công', data: rows[0] });
  } catch (e) {
    return res.status(400).json({ status: 'error', message: 'Dữ liệu không hợp lệ', data: {} });
  }
};

exports.remove = async (req, res) => {
  try {
    const { id } = req.params;
    const q = 'DELETE FROM memories WHERE id=$1 RETURNING id';
    const { rows } = await db.query(q, [id]);
    if (!rows[0]) return res.status(404).json({ status: 'error', message: 'Không tìm thấy', data: {} });
    return res.json({ status: 'success', message: 'Xóa thành công', data: rows[0] });
  } catch (e) {
    return res.status(500).json({ status: 'error', message: 'Lỗi máy chủ', data: {} });
  }
};





