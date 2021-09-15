
protocol _ProtobufDecodingKey: AnyObject {
    
    func decode(from container: _ProtobufDecodingContainer) throws
}
