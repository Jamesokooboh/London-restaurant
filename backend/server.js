const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
});

const SECRET = process.env.JWT_SECRET || 'dev-secret-change-me';
const sign = (u) => jwt.sign({ id: u.id }, SECRET, { expiresIn: '7d' });
const fail = (res, err) => { console.error(err); res.status(500).json({ error: 'Server error' }); };

app.get('/api/menu', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM menu ORDER BY id');
    res.json(result.rows);
  } catch (err) { fail(res, err); }
});

app.post('/api/signup', async (req, res) => {
  const { name, email, password } = req.body || {};
  if (!name || !/^\S+@\S+\.\S+$/.test(email || '') || (password || '').length < 8)
    return res.status(400).json({ error: 'Name, valid email and 8+ char password required' });
  try {
    const hash = await bcrypt.hash(password, 10);
    const { rows } = await pool.query(
      'INSERT INTO users (name, email, password_hash) VALUES ($1, lower($2), $3) RETURNING id, name, email',
      [String(name).trim(), email, hash]);
    res.status(201).json({ token: sign(rows[0]), user: rows[0] });
  } catch (err) {
    if (err.code === '23505') return res.status(409).json({ error: 'Email already registered' });
    fail(res, err);
  }
});

app.post('/api/signin', async (req, res) => {
  const { email, password } = req.body || {};
  try {
    const { rows } = await pool.query('SELECT * FROM users WHERE email = lower($1)', [String(email || '')]);
    const u = rows[0];
    if (!u || !(await bcrypt.compare(String(password || ''), u.password_hash)))
      return res.status(401).json({ error: 'Invalid email or password' });
    res.json({ token: sign(u), user: { id: u.id, name: u.name, email: u.email } });
  } catch (err) { fail(res, err); }
});

app.get('/api/me', async (req, res) => {
  try {
    const { id } = jwt.verify((req.headers.authorization || '').replace('Bearer ', ''), SECRET);
    const { rows } = await pool.query('SELECT id, name, email FROM users WHERE id = $1', [id]);
    if (!rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    res.json(rows[0]);
  } catch { res.status(401).json({ error: 'Unauthorized' }); }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Backend server running on port ${PORT}`));
