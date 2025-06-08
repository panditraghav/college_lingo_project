import express from "express";
import { getUserDetails, register, userProgress } from "../controllers/user.controller.js";
import { login } from "../controllers/user.controller.js";
import { updateProfile } from "../controllers/user.controller.js";
import { logout } from "../controllers/user.controller.js";
import isAuthenticated from "../middlewares/isAuthenticated.js";
import { singleUpload } from "../middlewares/multer.js";

const router = express.Router();

router.route("/register").post(singleUpload, register);
router.route("/login").post(login);
router.route("/logout").post(isAuthenticated,logout);
router.route("/profile/update").post(isAuthenticated, singleUpload, updateProfile);
router.route("/progress").get(isAuthenticated, userProgress);
router.route("/get").get(isAuthenticated, getUserDetails);

export default router;

