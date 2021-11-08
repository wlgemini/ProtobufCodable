
protocol _DecodingKey: AnyObject {
    
    func decode(from reader: _ByteBufferReader) throws
}
