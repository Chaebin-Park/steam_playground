import {corsHandler, API_KEY} from "./utils/corsAndApiKey";
import * as functions from "firebase-functions";
import axios from "axios";

const BASE_URL = "https://api.steampowered.com";
const OWNED_GAMES_ENDPOINT = "/IPlayerService/GetOwnedGames/v0001/";

const getOwnedGames = async (steamid: string) => {
  const response = await axios.get(`${BASE_URL}${OWNED_GAMES_ENDPOINT}`, {
    params: {steamid, key: API_KEY},
  });
  return response.data;
};

export const getOwnedGamesFunction = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const {steamid} = req.query;
    if (!steamid) {
      return res.status(400).send("Missing steamid parameter");
    }

    try {
      const ownedGames = await getOwnedGames(steamid as string);
      return res.status(200).json(ownedGames);
    } catch (error) {
      return res.status(500).send("Error fetching owned games from Steam API");
    }
  });
});
