
/// Wire Type
enum Wire: UInt8 {
    
    /// Use for: int32, int64, uint32, uint64, sint32, sint64, bool, enum
    case varint = 0
    
    /// Use for: fixed64, sfixed64, double
    case bit64 = 1
    
    /// Use for: string, bytes, embedded messages, packed repeated fields
    case lengthDelimited = 2
    
    /// Use for: groups (deprecated)
    case startGroup = 3
    
    /// Use for: groups (deprecated)
    case endGroup = 4
    
    /// Use for: fixed32, sfixed32, float
    case bit32 = 5
}

struct _Key {
    let fieldNumber: UInt
    let wireType: _WireType
}

struct _PayloadSize {
    
}

struct _Varint {
    
}
