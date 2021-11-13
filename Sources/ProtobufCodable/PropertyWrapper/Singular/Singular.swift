
/// For `Singular` namespace
///
/// List of scalar value type coding means:
/// - `double`: littleEndian.bit64, bitPattern
/// - `float`:  littleEndian.bit32, bitPattern
/// - `int32`:  littleEndian.varint, bitPattern
/// - `int64`:  littleEndian.varint, bitPattern
/// - `uint32`:  littleEndian.varint.bit32
/// - `uint64`:  littleEndian.varint.bit64
/// - `sint32`:  littleEndian.varint.bit32, zigzag
/// - `sint64`:  littleEndian.varint.bit64, zigzag
/// - `fixed32`: littleEndian.bit32
/// - `fixed64`: littleEndian.bit64
/// - `sfixed32`: littleEndian.bit32, bitPattern
/// - `sfixed64`: littleEndian.bit64, bitPattern
/// - `bool`: bit8
/// - `string`: littleEndian.[bit8], utf8
/// - `bytes`: littleEndian.[bit8]
///
public enum Singular {}
