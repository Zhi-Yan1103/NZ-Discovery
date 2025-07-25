package pccit.finalproject.javaclient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.type.CollectionType;

import java.util.List;

public class JSONUtils {
    private static final ObjectMapper mapper = new ObjectMapper();

    public static String toJSON(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }

    public static <T> T toObject(String json, Class<T> resultClass) throws JsonProcessingException {
        return mapper.readValue(json, resultClass);
    }

    public static <T> List<T> toList(String json, Class<T> resultClass) throws JsonProcessingException {
        CollectionType listType = mapper.getTypeFactory().constructCollectionType(List.class, resultClass);
        return mapper.readValue(json, listType);
    }
}
