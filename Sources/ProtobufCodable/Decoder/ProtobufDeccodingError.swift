
public enum ProtobufDeccodingError: Error {
    
    case unknowWireType
    case corruptedData(Swift.String)
}
