import express from "express";
import cookieParser from "cookie-parser";
import dotenv from "dotenv";
import connectDB from "./utils/db.js";
import userRoutes from "./routes/user.route.js";
import chatRoutes from "./routes/chat.route.js";
import lessonRoutes from "./routes/lesson.route.js";
import testRoutes from "./routes/test.route.js";
import morgan from "morgan";

dotenv.config({});
const app = express();

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(morgan("combined"));
const PORT = process.env.PORT || 3000;

// API's :

app.use("/api/v1/user", userRoutes);
app.use("/api/v1/chat", chatRoutes);
app.use("/api/v1/lessons", lessonRoutes);
app.use("/api/v1/test", testRoutes);

app.listen(PORT, () => {
  connectDB();
  console.log(`server running at port ${PORT}`);
});
