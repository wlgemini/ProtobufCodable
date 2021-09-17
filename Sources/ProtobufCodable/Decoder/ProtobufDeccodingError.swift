
public enum ProtobufDeccodingError: Error {
    
    case unknowWireType
    case corruptedData(String)
}
