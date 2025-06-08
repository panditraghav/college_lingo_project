import jwt from "jsonwebtoken";

const isAuthenticated = async (req, res, next) => {

    try {

        let token;
        let bearer = req.headers['authorization'];
        if (!bearer) {
            token = req.cookies.token;
            console.log("isAuthenticatedMW Token(Cookie)");
        } else {
            token = bearer.slice(7);
            console.log("isAuthenticatedMW Token(Header)");
        }
        if (!token) {
            return res.status(401).json({
                message: "User not authenticated!",
                succes: false
            })
        }

        const decode = jwt.verify(token, process.env.SECRET_KEY);
        if (!decode) {
            return res.status(401).json({
                message: "Invalid token",
                succes: false
            })
        }

        req.id = decode.userID;
        next();

    } catch (error) {
        console.log(error);
    }
}

export default isAuthenticated;
