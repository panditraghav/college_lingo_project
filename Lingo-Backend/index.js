import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import dotenv from "dotenv";
import connectDB from "./utils/db.js";
import userRoutes from "./routes/user.route.js";
import grammarLessonRoutes from "./routes/grammarLesson.route.js";
import chatRoutes from "./routes/chat.route.js";

dotenv.config({});
const app = express();

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
const corsOptions = {
  origin: "*",
  credentials: true,
};
app.use(cors(corsOptions));

const PORT = process.env.PORT || 3000;

// API's :

app.use("/api/v1/user", userRoutes);
app.use("/api/v1/grammar-lessons", grammarLessonRoutes);
app.use("/api/v1/chat", chatRoutes);

app.listen(PORT, () => {
  connectDB();
  console.log(`server running at port ${PORT}`);
});
