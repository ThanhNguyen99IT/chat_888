const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');

// POST /api/auth/register - Đăng ký
router.post('/register', authController.register);

// POST /api/auth/login - Đăng nhập
router.post('/login', authController.login);

// GET /api/auth/profile - Lấy thông tin user (cần token)
router.get('/profile', authController.getProfile);

module.exports = router;
