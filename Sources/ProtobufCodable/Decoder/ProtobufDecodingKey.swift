
protocol ProtobufDecodingKey: AnyObject {
    
    func decode(from container: ProtobufDecodingContainer)
}
