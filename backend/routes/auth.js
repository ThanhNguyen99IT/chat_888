const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');

// POST /api/auth/register - Đăng ký
router.post('/register', authController.register);

// POST /api/auth/login - Đăng nhập
router.post('/login', authController.login);

// GET /api/auth/profile - Lấy thông tin user (cần token)
router.get('/profile', authController.getProfile);

// POST /api/auth/upload-avatar - Upload ảnh đại diện (cần token)
router.post('/upload-avatar', authController.uploadMiddleware, authController.handleMulterError, authController.uploadAvatar);

module.exports = router;
