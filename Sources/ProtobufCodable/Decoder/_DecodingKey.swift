
protocol _DecodingKey: AnyObject {
    
    func decode(from decoder: ProtobufDecoder) throws
}
