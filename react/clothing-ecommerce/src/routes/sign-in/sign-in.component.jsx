import { useEffect } from "react";
import { getRedirectResult } from "firebase/auth";

import {
    createUserDocumentFromAuth,
    signInWithGooglePopup,
    signInWithGoogleRedirect
} from "../../utils/firebase/firebase.utils";

const SignIn = () => {

    useEffect(async () => {
        const response = await getRedirectResult(auth); // auth is singleton, keep track of all auth states in app
        if (response) {
            const userDocRef = await createUserDocumentFromAuth(response.user)
        }
    }, []);

    const logGoogleUser = async () => {
        const { user } = await signInWithGooglePopup();
        const userDocRef = await createUserDocumentFromAuth(user);
    };

    return (
        <div>
            <h1>Sign In Page</h1>
            <button onClick={logGoogleUser}>Sign in with Google Popup</button>
            <button onClick={signInWithGoogleRedirect}>Sign in with Google Redirect</button>
        </div>
    );
}

export default SignIn;