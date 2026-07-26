using System;

namespace AgoraIO.Media
{
    /// <summary>
    /// Stores Token007 bytes in a dynamically growing buffer and reads them from left to right.
    /// </summary>
    public class ByteBuffer
    {
        private const int INITIAL_CAPACITY = 1024;

        private byte[] TEMP_BYTE_ARRAY = new byte[INITIAL_CAPACITY];

        // Stores the number of bytes currently written to the buffer.
        private int CURRENT_LENGTH = 0;

        // Stores the current read position.
        private int CURRENT_POSITION = 0;

        // Stores the byte array returned by ToByteArray.
        private byte[] RETURN_ARRAY;

        /// <summary>
        /// Initializes an empty byte buffer.
        /// </summary>
        public ByteBuffer()
        {
            this.Initialize();
        }

        /// <summary>
        /// Initializes a byte buffer with the specified bytes.
        /// </summary>
        /// <param name="bytes">The bytes used to initialize the buffer.</param>
        public ByteBuffer(byte[] bytes)
        {
            this.Initialize();
            this.PushByteArray(bytes);
        }

        /// <summary>
        /// Gets the number of bytes currently stored in the buffer.
        /// </summary>
        public int Length
        {
            get
            {
                return CURRENT_LENGTH;
            }
        }

        /// <summary>
        /// Gets or sets the current read position.
        /// </summary>
        public int Position
        {
            get
            {
                return CURRENT_POSITION;
            }
            set
            {
                CURRENT_POSITION = value;
            }
        }

        /// <summary>
        /// Returns the bytes currently stored in the buffer.
        /// </summary>
        /// <returns>A byte array containing the stored data.</returns>
        public byte[] ToByteArray()
        {
            // Allocate an array containing only the written bytes.
            RETURN_ARRAY = new byte[CURRENT_LENGTH];
            // Copy the written bytes into the result array.
            Array.Copy(TEMP_BYTE_ARRAY, 0, RETURN_ARRAY, 0, CURRENT_LENGTH);
            return RETURN_ARRAY;
        }

        /// <summary>
        /// Clears the buffer and resets the read position.
        /// </summary>
        public void Initialize()
        {
            TEMP_BYTE_ARRAY.Initialize();
            CURRENT_LENGTH = 0;
            CURRENT_POSITION = 0;
        }

        /// <summary>
        /// Grows the backing array when the next value does not fit.
        /// </summary>
        private void EnsureCapacity(int additionalLength)
        {
            int requiredLength = CURRENT_LENGTH + additionalLength;
            if (requiredLength <= TEMP_BYTE_ARRAY.Length)
            {
                return;
            }

            int capacity = TEMP_BYTE_ARRAY.Length;
            while (capacity < requiredLength)
            {
                capacity *= 2;
            }

            Array.Resize(ref TEMP_BYTE_ARRAY, capacity);
        }

        /// <summary>
        /// Appends one byte to the buffer.
        /// </summary>
        /// <param name="by">The byte to append.</param>
        public void PushByte(byte by)
        {
            EnsureCapacity(1);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = by;
        }

        /// <summary>
        /// Appends a byte array to the buffer.
        /// </summary>
        /// <param name="ByteArray">The byte array to append.</param>
        public void PushByteArray(byte[] ByteArray)
        {
            EnsureCapacity(ByteArray.Length);
            // Copy the source bytes into the backing array.
            ByteArray.CopyTo(TEMP_BYTE_ARRAY, CURRENT_LENGTH);
            // Advance the written length.
            CURRENT_LENGTH += ByteArray.Length;
        }

        /// <summary>
        /// Appends a two-byte unsigned integer in little-endian order.
        /// </summary>
        /// <param name="Num">The UInt16 value to append.</param>
        public void PushUInt16(UInt16 Num)
        {
            EnsureCapacity(2);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)((Num & 0x00ff) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0xff00) >> 8) & 0xff);
        }

        /// <summary>
        /// Appends a four-byte unsigned integer in little-endian order.
        /// </summary>
        /// <param name="Num">The UInt32 value to append.</param>
        public void PushInt(UInt32 Num)
        {
            EnsureCapacity(4);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)((Num & 0x000000ff) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0x0000ff00) >> 8) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0x00ff0000) >> 16) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0xff000000) >> 24) & 0xff);
        }

        /// <summary>
        /// Appends the lower four bytes of a long value in little-endian order.
        /// </summary>
        /// <param name="Num">The long value to append.</param>
        public void PushLong(long Num)
        {
            EnsureCapacity(4);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)((Num & 0x000000ff) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0x0000ff00) >> 8) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0x00ff0000) >> 16) & 0xff);
            TEMP_BYTE_ARRAY[CURRENT_LENGTH++] = (byte)(((Num & 0xff000000) >> 24) & 0xff);
        }

        /// <summary>
        /// Reads one byte and advances the read position by one byte.
        /// </summary>
        /// <returns>The next byte.</returns>
        public byte PopByte()
        {
            byte ret = TEMP_BYTE_ARRAY[CURRENT_POSITION++];
            return ret;
        }

        /// <summary>
        /// Reads a UInt16 in little-endian order and advances the read position by two bytes.
        /// </summary>
        /// <returns>The next UInt16 value, or zero when insufficient bytes remain.</returns>
        public UInt16 PopUInt16()
        {
            // Return zero when insufficient bytes remain.
            if (CURRENT_POSITION + 1 >= CURRENT_LENGTH)
            {
                return 0;
            }
            // UInt16 ret = (UInt16)(TEMP_BYTE_ARRAY[CURRENT_POSITION] << 8 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 1]);
            UInt16 ret = (UInt16)(TEMP_BYTE_ARRAY[CURRENT_POSITION] | TEMP_BYTE_ARRAY[CURRENT_POSITION + 1] << 8);
            CURRENT_POSITION += 2;
            return ret;
        }

        /// <summary>
        /// Reads a UInt32 in little-endian order and advances the read position by four bytes.
        /// </summary>
        /// <returns>The next UInt32 value, or zero when insufficient bytes remain.</returns>
        public uint PopUInt()
        {
            if (CURRENT_POSITION + 3 >= CURRENT_LENGTH)
                return 0;
            uint ret = (uint)(TEMP_BYTE_ARRAY[CURRENT_POSITION] | TEMP_BYTE_ARRAY[CURRENT_POSITION + 1] << 8 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 2] << 16 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 3] << 24);
            CURRENT_POSITION += 4;
            return ret;
        }

        /// <summary>
        /// Reads four bytes as a long value and advances the read position by four bytes.
        /// </summary>
        /// <returns>The next four-byte long value, or zero when insufficient bytes remain.</returns>
        public long PopLong()
        {
            if (CURRENT_POSITION + 3 >= CURRENT_LENGTH)
                return 0;
            long ret = (long)(TEMP_BYTE_ARRAY[CURRENT_POSITION] << 24 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 1] << 16 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 2] << 8 | TEMP_BYTE_ARRAY[CURRENT_POSITION + 3]);
            CURRENT_POSITION += 4;
            return ret;
        }

        /// <summary>
        /// Reads the specified number of bytes and advances the read position.
        /// </summary>
        /// <param name="Length">The number of bytes to read.</param>
        /// <returns>The requested bytes, or an empty array when insufficient bytes remain.</returns>
        public byte[] PopByteArray(int Length)
        {
            // Return an empty array when insufficient bytes remain.
            if (CURRENT_POSITION + Length > CURRENT_LENGTH)
            {
                return new byte[0];
            }
            byte[] ret = new byte[Length];
            Array.Copy(TEMP_BYTE_ARRAY, CURRENT_POSITION, ret, 0, Length);
            // Advance the read position.
            CURRENT_POSITION += Length;
            return ret;
        }

        /// <summary>
        /// Reads bytes immediately before the current position and moves the position backward.
        /// </summary>
        /// <param name="Length">The number of bytes to read.</param>
        /// <returns>The requested bytes, or an empty array when the position is too small.</returns>
        public byte[] PopByteArray2(int Length)
        {
            // Return an empty array when the position is too small.
            if (CURRENT_POSITION <= Length)
            {
                return new byte[0];
            }
            byte[] ret = new byte[Length];
            Array.Copy(TEMP_BYTE_ARRAY, CURRENT_POSITION - Length, ret, 0, Length);
            // Move the read position backward.
            CURRENT_POSITION -= Length;
            return ret;
        }
    }
}
