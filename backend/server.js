require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
const authRoutes = require('./routes/auth');
const memoriesRoutes = require('./routes/memories');

app.use('/api/auth', authRoutes);
app.use('/api/memories', memoriesRoutes);

// Health check endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'success',
    message: '🚀 Chat 888 API đang hoạt động',
    data: {
      version: '1.0.0',
      endpoints: {
        auth: '/api/auth (register, login, profile)',
        memories: '/api/memories (CRUD operations)'
      }
    }
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Endpoint không tồn tại',
    data: {}
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server Error:', err);
  res.status(500).json({
    status: 'error',
    message: 'Lỗi máy chủ nội bộ',
    data: {}
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server đang chạy tại http://localhost:${PORT}`);
  console.log(`📊 Database: datatest`);
  console.log(`🔐 Auth endpoints: /api/auth/register, /api/auth/login`);
});
