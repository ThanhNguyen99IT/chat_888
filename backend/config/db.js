const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'datatest',
  password: process.env.DB_PASSWORD || 'Nguyen88$',
  port: process.env.DB_PORT || 5432,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Test connection
pool.connect()
  .then(client => {
    console.log('✅ Kết nối PostgreSQL database "datatest" thành công');
    client.release();
  })
  .catch(err => console.error('❌ Lỗi kết nối PostgreSQL:', err));

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool
};





