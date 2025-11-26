Jasa Tukang - Starter Kit (Frontend + Backend + SQL)

Cara pakai (lokal):
1. Import / jalankan file schema.sql di MySQL untuk membuat database dan tabel.
2. Atur environment variables jika perlu:
   - DB_HOST, DB_USER, DB_PASS, DB_NAME (default: tukang_db)
   - JWT_SECRET (recommended)
3. Jalankan `npm install` di folder project, lalu `npm start`.
4. Buka file frontend (index.html) langsung di browser OR jalankan server static seperti `npx http-server`.
5. API berjalan di http://localhost:3000

File penting:
- index.js     (backend)
- package.json
- schema.sql   (MySQL schema)
- index.html, login.html, register.html, booking.html (frontend)
