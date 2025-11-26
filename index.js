const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const SECRET = process.env.JWT_SECRET || 'dev_secret_change_me';

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || '',
  database: process.env.DB_NAME || 'tukang_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

async function query(sql, params=[]) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

// Register pelanggan
app.post('/api/register', async (req,res) => {
  const { nama, email, password, alamat, no_telefon } = req.body;
  if (!email || !password || !nama) return res.status(400).json({ error: 'nama, email, password required' });
  const pass = await bcrypt.hash(password, 10);
  try {
    const r = await query('INSERT INTO pelanggan (nama,email,password,alamat,no_telefon) VALUES (?,?,?,?,?)', [nama,email,pass,alamat,no_telefon]);
    res.json({ ok: true, insertId: r.insertId });
  } catch(err) {
    res.status(400).json({ error: err.message });
  }
});

// Login pelanggan (simple)
app.post('/api/login', async (req,res) => {
  const { email, password } = req.body;
  try {
    const rows = await query('SELECT * FROM pelanggan WHERE email = ?', [email]);
    if (!rows.length) return res.status(401).json({ error: 'user not found' });
    const user = rows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ error: 'invalid credentials' });
    const token = jwt.sign({ id: user.pelanggan_id, role: 'pelanggan' }, SECRET, { expiresIn: '8h' });
    res.json({ token, user: { id: user.pelanggan_id, nama: user.nama, email: user.email } });
  } catch(err) {
    res.status(500).json({ error: err.message });
  }
});

// List tukang
app.get('/api/tukang', async (req,res) => {
  try {
    const rows = await query('SELECT tukang_id,nama,spesialisasi,alamat,no_telepon,rating_avg FROM tukang');
    res.json(rows);
  } catch(e) { res.status(500).json({ error: e.message }); }
});

// Create permintaan
app.post('/api/permintaan', async (req,res) => {
  const { pelanggan_id, tukang_id, alamat_pekerjaan, keterangan } = req.body;
  try {
    const r = await query('INSERT INTO permintaan (pelanggan_id,tukang_id,alamat_pekerjaan,keterangan) VALUES (?,?,?,?)', [pelanggan_id,tukang_id,alamat_pekerjaan,keterangan]);
    res.json({ ok: true, insertId: r.insertId });
  } catch(e) { res.status(500).json({ error: e.message }); }
});

const port = process.env.PORT || 3000;
app.listen(port, ()=> console.log('API running on http://localhost:'+port));
