import { User } from "../models/user.model.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import getDataUri from "../utils/datauri.js";
import cloudinary from "../utils/cloudinary.js"


// 1. Named Exports vs Default Exports
// In JavaScript ES6 modules, there are two types of exports:

// Named Exports (Exporting multiple items from a module): You can export multiple variables, functions, or classes from a module. When importing a named export, you must use the exact name of the exported item within curly braces {}.

// Default Exports (Exporting a single item from a module): A module can have only one default export. When importing a default export, no curly braces are needed, and you can assign any name to the imported module.


export const register = async (req, res) => {

    try {
        const { fullName, email, phoneNumber, password, role } = req.body;
        if (!fullName || !email || !phoneNumber || !password || !role) {
            return res.status(400).json({
                message: "something is missing",
                success: false
            });
        }
        const file = req.file;
        if (file) {
            try {
                const fileUri = getDataUri(file);
                console.log("fileUri length:", fileUri.content.length);
                const cloudResponse = await cloudinary.uploader.upload(fileUri.content);
                var profilePhotoUrl = cloudResponse.secure_url;
            } catch (uploadErr) {
                console.error("Cloudinary upload failed:", uploadErr);
                return res.status(500).json({
                    message: "File upload to Cloudinary failed.",
                    success: false,
                    error: uploadErr.message
                });
            }
        }
        const user = await User.findOne({ email });
        if (user) {
            return res.status(400).json({
                message: "user already exist with this email.",
                success: false
            })
        }
        const hashedPassword = await bcrypt.hash(password, 10); // const and let have scope limited to the block whereas var has global scope. 

        try {
            await User.create({
                fullName,
                email,
                phoneNumber,
                password: hashedPassword,
                role,
                profile: {
                    profilePhoto: profilePhotoUrl,
                }
            });
        } catch (dbErr) {
            console.error("User DB creation failed:", dbErr);
            return res.status(500).json({
                message: "User creation failed.",
                success: false,
                error: dbErr.message
            });
        }
        res.status(201).json({
            message: "Account created successfully!",
            success: true
        })

    } catch (error) {
        res.status(500).json({
            message: "An error occurred in registration process!",
            success: false,
            error: error.message
        });
    }
}





export const login = async (req, res) => {

    try {

        const { email, password, role } = req.body;// getting credentials

        if (!email || !password || !role) // verifying if anything is missing
        {
            return res.status(400).json({
                message: "email or password is missing",
                success: false
            })
        }

        let user = await User.findOne({ email }); // fetch the user using the email
        if (!user) {   // check if the user exist with that mail
            return res.status(400).json({
                message: "user doesn't exist with this E-mail! please try another E-mail ID.",
                success: false
            })
        }

        const isPasswordMatched = await bcrypt.compare(password, user.password); // password verification
        if (!isPasswordMatched) {
            return res.status(400).json({
                message: "Wrong Password!",
                success: false
            })
        }

        if (role !== user.role) {
            return res.status(400).json({
                message: "Role doesn't match!",
                success: false
            })
        }

        //         1. Equality (==)
        // Compares values for equality but performs type coercion if the types are different.
        // This means it will attempt to convert one or both operands to a common type before comparing.

        // Example:

        // console.log(5 == '5'); // true (string '5' is coerced to number 5)
        // console.log(true == 1); // true (true is coerced to 1)
        // console.log(null == undefined); // true (special case)
        // console.log(0 == false); // true (0 is coerced to false)

        // When to use:
        // Rarely recommended due to potential confusion from type coercion.


        //          2. Strict Equality (===)
        // Compares both value and type without performing type coercion.
        // If the types are different, the result is always false.

        // Example:

        // console.log(5 === '5'); // false (different types)
        // console.log(5 === 5); // true (same value and type)
        // console.log(false === 0); // false (different types)
        // console.log(null === undefined); // false (different types)

        // When to use:
        // Always prefer strict equality (===) to avoid unexpected results due to type coercion.

        // 3. Inequality Operators

        // Loose Inequality (!=):
        // Checks if two values are not equal, with type coercion.

        // Example:

        // console.log(5 != '5'); // false (string '5' is coerced to number 5)
        // console.log(false != 0); // false (false is coerced to 0)
        // console.log(null != undefined); // false (special case)

        // Strict Inequality (!==):
        // Checks if two values are not equal, without type coercion. Types must also be different.
        // Example:

        // console.log(5 !== '5'); // true (different types)
        // console.log(5 !== 5); // false (same value and type)
        // console.log(false !== 0); // true (different types)


        // Special Cases to Note:

        //1.  null and undefined:


        // console.log(null == undefined); // true
        // console.log(null === undefined); // false

        // 2. NaN (Not-a-Number):

        // "NaN" is not equal to anything, including itself.

        // console.log(NaN == NaN); // false
        // console.log(NaN === NaN); // false
        // console.log(Object.is(NaN, NaN)); // true (use Object.is for precise checks)

        // 3. Objects:

        // Equality operators compare object references, not the contents.

        // const obj1 = { a: 1 };
        // const obj2 = { a: 1 };
        // console.log(obj1 == obj2); // false
        // console.log(obj1 === obj2); // false
        // console.log(obj1 === obj1); // true (same reference)



        const tokenData = {
            userID: user._id
        }
        const token = await jwt.sign(tokenData, process.env.SECRET_KEY, { expiresIn: '1d' });
        user = {
            _id: user._id,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            role: user.role,
            profile: user.profile
        }
        return res.status(200).cookie("token", token, { maxAge: 1 * 24 * 60 * 60 * 1000, httpsOnly: true, sameSit: 'strict' }).json({
            message: `Welcome back ${user.fullName}`,
            user,
            success: true
        })



    } catch (error) {

        res.status(500).json({
            message: "An error occurred in login process!",
            success: false,
            error: error.message
        });

    }


}





export const logout = async (req, res) => {


    try {
        return res.status(200).cookie("token", "", { maxAge: 0 }).json({
            message: "User logged out successfully!",
            success: true
        })
    } catch (error) {
        res.status(500).json({
            message: "An error occurred in login process!",
            success: false,
            error: error.message
        });

    }
}




export const updateProfile = async (req, res) => {
    try {


        const { fullName, email, phoneNumber, bio, skills } = req.body;

        const file = req.file;

        if (file) {
            const fileUri = getDataUri(file);
            console.log(fileUri.content.substring(0, 100));

            var cloudResponse = await cloudinary.uploader.upload(fileUri.content, { resource_type: "raw" });
            // cloudinary will come here
        }


        let skillsArray;
        if (skills) {
            skillsArray = skills.split(",").map(skill => skill.trim());
        }

        const userId = req.id; // middleware authentication
        console.log(userId);

        let user = await User.findById(userId)

        if (!user) {
            return res.status(400).json({
                message: "user not found!",
                success: false
            })
        }

        // updating user info

        if (fullName) user.fullName = fullName
        if (email) user.email = email;
        if (phoneNumber) user.phoneNumber = phoneNumber
        if (bio) user.profile.bio = bio
        if (skills) user.profile.skills = skillsArray


        if (cloudResponse) {
            user.profile.resume = cloudResponse.secure_url;
            user.profile.resumeOriginalName = file.originalname; // save the original file name
        }

        await user.save(); // update user

        user = {
            _id: user._id,
            fullName: user.fullName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            role: user.role,
            profile: user.profile
        }

        return res.status(200).json({
            message: "User data updated successfully!",
            user,
            success: true
        })

    } catch (error) {

        res.status(500).json({
            message: "An error occurred in update process!",
            success: false,
            error: error.message
        });

    }
}