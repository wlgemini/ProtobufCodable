
protocol _EncodingKey: AnyObject {
    
    func encode(to encoder: ProtobufEncoder) throws
}
