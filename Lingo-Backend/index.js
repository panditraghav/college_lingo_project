import express from "express";
import cookieParser from "cookie-parser";
import dotenv from "dotenv";
import connectDB from "./utils/db.js";
import userRoutes from "./routes/user.route.js";
import lessonRoutes from "./routes/lesson.route.js";
import testRoutes from "./routes/test.route.js"
import { register } from "./controllers/user.controller.js";

dotenv.config({});
const app = express();

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
const PORT = 3000;

// API's :

app.use("/api/v1/user", userRoutes);
app.use("/api/v1/lessons", lessonRoutes);
app.use("/api/v1/test", testRoutes);

app.listen(PORT, () => {
  connectDB();
  console.log(`server running at port ${PORT}`);
});

