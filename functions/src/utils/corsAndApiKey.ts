import cors from 'cors';  // 기본 내보내기를 사용하여 import
import * as functions from "firebase-functions";

// CORS 처리
export const corsHandler = cors({origin: true});

// API Key 가져오기
export const API_KEY = functions.config().steam.apikey;
