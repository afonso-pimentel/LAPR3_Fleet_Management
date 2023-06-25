package lapr.project.utils.utilities;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Array;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author Group 169 LAPRIII
 */
public class Utilities {
    private Utilities(){}

    /**
     * Converts a string represention of a date to a Timestamp
     * @param input String representation of the date
     * @return Date has a TimeStamp
     * @throws ParseException
     */
    public static Timestamp convertFromDateStringToTimeStamp(String input) throws ParseException {
        if(input == null || input.isEmpty())
            throw new IllegalArgumentException("Input cannot be null or empty");

        return new Timestamp(
                new SimpleDateFormat("dd/MM/yyyy HH:mm")
                        .parse(input)
                        .getTime());
    }

    /**
     * Converts the specified inputStream to it's String representation
     * @param inputStream InputStream
     * @return String
     */
    public static String convertInputStreamToString(InputStream inputStream){
        if(inputStream == null)
            throw new IllegalArgumentException("inputStream argumment cannot be null");

        return new BufferedReader(new InputStreamReader(inputStream))
                .lines().collect(Collectors.joining("\n"));
    }


    /**
     * returns sum of all the elements in the float arraylist
     * @param arrayList
     * @return
     */
    public static Float sumFloatArrayList(List<Float> arrayList){
        float sum = 0f;
        for (Float element:arrayList) {
            sum=sum+element;
        }
        return sum;
    }

    /***
     * check is key exists in hashMap, if exists increment its value, if not add and set value to 0
     * @param hashMap
     * @param key
     * @param <V>
     */
    public static <V> void addItemToMapAndIncrementOneOnValue(HashMap<V,Long> hashMap, V key){
        if(hashMap.containsKey(key))
        {
            Long sum = hashMap.get(key);
            sum++;
            hashMap.put(key, sum);
        }else {
            hashMap.put(key, 1L);
        }
    }

    /****
     * This function will sort thw hashmap by is value, base on value compareTo
     * @param unsortMap
     * @param asc
     * @return
     */
    public static <K,V extends Comparable> LinkedHashMap<K, V> sortMapByValueComparator(HashMap<K,V> unsortMap, final boolean asc)
    {
        List<Map.Entry<K,V>> list = new LinkedList(unsortMap.entrySet());

        // Sorting the list based on values
        Collections.sort(list, (o1, o2) -> {
            if (asc)
                return o1.getValue().compareTo(o2.getValue());
            else
                return o2.getValue().compareTo(o1.getValue());
        });

        // Maintaining insertion order with the help of LinkedList
        LinkedHashMap<K,V> sortedMap = new LinkedHashMap();
        for (Map.Entry<K,V> entry : list)
            sortedMap.put(entry.getKey(), entry.getValue());

        return sortedMap;
    }

    /***
     * Validates if is to filter the graph and if the node is valid
     * @param methodValidate
     * @param node
     * @param <V>
     * @return
     */
    public static <V> boolean validateNode(ValidateGraphNodes methodValidate, V node){
        if (methodValidate == null)
            return true;

        return methodValidate.valid(node);
    }
}
