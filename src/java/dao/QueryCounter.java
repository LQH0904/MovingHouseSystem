package dao;

public class QueryCounter {
    private static int queryCount = 0;

    public static synchronized void increaseQueryCount() {
        queryCount++;
    }

    public static int getQueryCount() {
        return queryCount;
    }
}
