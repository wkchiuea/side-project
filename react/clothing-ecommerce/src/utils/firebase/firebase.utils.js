import { initializeApp } from "firebase/app";
import {
    getAuth,
    signInWithRedirect,
    signInWithPopup,
    GoogleAuthProvider,
    createUserWithEmailAndPassword
} from 'firebase/auth';
import {getFirestore, doc, getDoc, setDoc} from "firebase/firestore";


// dummy config
const firebaseConfig = {
    apiKey: "AIzaSyAxvan7VPOG4HPNVSppQY30_Pd3MdeopJs",
    authDomain: "react-clothing-db-efc31.firebaseapp.com",
    projectId: "react-clothing-db-efc31",
    storageBucket: "react-clothing-db-efc31.appspot.com",
    messagingSenderId: "202402566107",
    appId: "1:202402566107:web:893cdb2a4f0aec5746e1fe"
};

const firebaseApp = initializeApp(firebaseConfig);

const provider = new GoogleAuthProvider();
provider.setCustomParameters({
    prompt: "select_account"
});
export const auth = getAuth();
export const signInWithGooglePopup = () => signInWithPopup(auth, provider);
export const signInWithGoogleRedirect = () => signInWithRedirect(auth, provider);


// create user profile in firestore
export const db = getFirestore();
export const createUserDocumentFromAuth = async (userAuth, additionalInformation) => {
    if (!userAuth) {
        return;
    }

    const userDocRef = doc(db, 'users', userAuth.id);

    const userSnapshot = await getDoc(userDocRef);

    if (!userSnapshot.exists()) {
        const {displayName, email} = userAuth;
        const createdAt = new Date();

        try {
            await setDoc(userDocRef, {
                displayName,
                email,
                createdAt,
                ...additionalInformation
            });
        } catch (error) {
            console.log("error creating the user", error.message);
        }

    }

    return userDocRef;

};


// add create user with email and password
export const createAuthUserWithEmailAndPasswowrd = async (email, password) => {
    if (!email || !password) {
        return;
    }

    return await createUserWithEmailAndPassword(email, password);
}

