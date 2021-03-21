namespace AgoraIO.Media
{
    public interface IPackable
    {
        ByteBuf marshal(ByteBuf outBuf);

        void unmarshal(ByteBuf inBuf);
    }
}
