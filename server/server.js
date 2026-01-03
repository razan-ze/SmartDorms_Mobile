const express = require("express");
const mysql = require("mysql");
const cors = require("cors");
const db = require("./config/database");
const path = require("path");
const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use("/assets/dorms", express.static(path.join(__dirname, "assets/dorms")));


// ================= AUTH =================

// ================= SIGNUP =================
app.post("/signup", (req, res) => {
  const { username, password, address, phone } = req.body;

  // Check if username already exists
  const check = "SELECT id FROM students WHERE username = ?";
  db.query(check, [username], (err, data) => {
    if (err) return res.status(500).json(err);
    if (data.length)
      return res.status(400).json({ message: "Username exists" });

    // Insert new student
    const q =
      "INSERT INTO students (username, password, address, phone) VALUES (?,?,?,?)";
    db.query(q, [username, password, address, phone], (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, username, address, phone });
    });
  });
});

// ================= LOGIN =================
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  // Check credentials in students table
  const q =
    "SELECT id, username, address, phone FROM students WHERE username = ? AND password = ?";
  db.query(q, [username, password], (err, data) => {
    if (err) return res.status(500).json(err);
    if (!data.length)
      return res.status(401).json({ message: "Invalid credentials" });

    res.json(data[0]);
  });
});


// ================= DORMS =================

// GET ALL DORMS
app.get("/dorms", (req, res) => {
  const q = "SELECT id, name, city, university, price, images FROM dorms";
  db.query(q, (err, data) => {
    if (err) return res.status(500).json(err);

    // Convert images string to array of URLs
    data.forEach(dorm => {
      dorm.images = dorm.images ? dorm.images.split(",") : [];
    });

    res.json(data);
  });
});

// GET SINGLE DORM BY ID
app.get("/dorm/:id", (req, res) => {
  const q = "SELECT * FROM dorms WHERE id = ?";
  db.query(q, [req.params.id], (err, data) => {
    if (err) return res.status(500).json(err);
    if (!data.length) return res.status(404).json({ message: "Dorm not found" });

    const dorm = data[0];
    dorm.images = dorm.images ? dorm.images.split(",") : [];

    res.json(dorm);
  });
});



// ================= PROFILE =================
app.put("/students/:id", (req, res) => {
  const { address, phone } = req.body;
  const studentId = req.params.id;

  if (!address && !phone) {
    return res.status(400).json({ message: "Nothing to update" });
  }

  const q = "UPDATE students SET address = ?, phone = ? WHERE id = ?";
  db.query(q, [address, phone, studentId], (err, result) => {
    if (err) return res.status(500).json(err);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Student not found" });
    }

    const s = "SELECT id, username, address, phone FROM students WHERE id = ?";
    db.query(s, [studentId], (err2, data) => {
      if (err2) return res.status(500).json(err2);

      res.json(data[0]);
    });
  });
});



// ================= FAVORITE =================
app.post("/addFavorite", (req, res) => {
  const { student_id, dorm_id } = req.body; // use same names as DB
  const q = "INSERT INTO favorites (student_id,dorm_id) VALUES (?,?)";
  db.query(q, [student_id, dorm_id], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Added to favorites" });
  });
});

// GET FAVORITES BY USER
app.get("/favorites/:studentId", (req, res) => {
  const q = `
    SELECT dorms.*
    FROM dorms
    JOIN favorites ON dorms.id = favorites.dorm_id
    WHERE favorites.student_id = ?
  `;
  db.query(q, [req.params.studentId], (err, data) => {
    if (err) return res.status(500).json(err);

    // Convert images string to array of URLs
    data.forEach(d => {
      d.images = d.images ? d.images.split(",") : [];
    });

    res.json(data);
  });
});
// ================= REMOVE FAVORITE =================
app.delete("/removeFavorite", (req, res) => {
  const { student_id, dorm_id } = req.body;
  const q = "DELETE FROM favorites WHERE student_id = ? AND dorm_id = ?";

  db.query(q, [student_id, dorm_id], (err) => {
    if (err) {
      console.log("Error deleting:", err);
      return res.status(500).json(err);
    }
    
    res.json({ message: "Removed successfully" });
  });
});
// ================= Search =================
// SEARCH API
app.get("/dorms/search", (req, res) => {
  const { q } = req.query; // ?q=someQuery
  const searchQuery = `%${q}%`;

  const sql = `
    SELECT * FROM dorms
    WHERE name LIKE ? OR city LIKE ? OR university LIKE ?
  `;

  db.query(sql, [searchQuery, searchQuery, searchQuery], (err, data) => {
    if (err) return res.status(500).json(err);

    // Convert images string to array of URLs
    data.forEach(d => {
      d.images = d.images ? d.images.split(",") : [];
    });

    res.json(data);
  });
});

// ================= SERVER =================
app.listen(port, () => {
  console.log("UniStay Student API running on port " + port);
});