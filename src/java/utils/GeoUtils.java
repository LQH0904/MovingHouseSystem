package utils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;

public class GeoUtils {

    public static class Coordinate {
        public double lat;
        public double lon;

        public Coordinate(double lat, double lon) {
            this.lat = lat;
            this.lon = lon;
        }
    }

    public static Coordinate getCoordinates(String address) {
        try {
            String encodedAddress = URLEncoder.encode(address, "UTF-8");
            String urlString = "https://nominatim.openstreetmap.org/search?q=" + encodedAddress + "&format=json&limit=1";

            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder jsonText = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonText.append(line);
            }
            reader.close();

            JSONArray jsonArray = new JSONArray(jsonText.toString());
            if (jsonArray.length() > 0) {
                JSONObject obj = jsonArray.getJSONObject(0);
                double lat = obj.getDouble("lat");
                double lon = obj.getDouble("lon");
                return new Coordinate(lat, lon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // nếu không lấy được tọa độ
    }
}
