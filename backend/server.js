const express = require("express");
const cors = require("cors");
require("dotenv").config();

const { createClient } = require("@supabase/supabase-js");

const app = express();

app.use(cors());
app.use(express.json());

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

app.get("/", (req, res) => {
  res.json({
    message: "Brahmo Data Integrity Backend Running"
  });
});

app.get("/nodes", async (req, res) => {
  const { data, error } = await supabase
    .from("knowledge_nodes")
    .select("*");

  if (error) {
    return res.status(500).json({
      error: error.message
    });
  }

  res.json(data);
});

app.get("/audit", async (req, res) => {
  const { data, error } = await supabase
    .from("audit_log")
    .select("*")
    .order("timestamp", { ascending: false });

  if (error) {
    return res.status(500).json({
      error: error.message
    });
  }

  res.json(data);
});

app.listen(process.env.PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`);
});