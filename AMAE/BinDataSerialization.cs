using System;
using System.IO;
using System.Drawing;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace AMAE
{
    class BinDataSerialization
    {
        public static Dictionary<int, Color[][]> Open(string Path)
        {
            if (!File.Exists(Path)) throw new FileNotFoundException();

            using (Stream stream = new FileStream(Path, FileMode.Open))
            {
                IFormatter formatter = new BinaryFormatter();
                object data = formatter.Deserialize(stream);

                stream.Close();
                GC.Collect();

                return (data as Dictionary<int, Color[][]>);
            }
        }

        public static void Save(Dictionary<int, Color[][]> bitmaps, string path)
        {
            //new Thread(() => {
            using (Stream stream = new FileStream(path, FileMode.Create))
            {
                IFormatter formatter = new BinaryFormatter();
                formatter.Serialize(stream, bitmaps);

                stream.Close();
            }

            GC.Collect();
            //}).Start();
        }
    }
}
