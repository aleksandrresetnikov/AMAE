using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AMAE
{
    public partial class MatrixView : UserControl
    {
        private int _Size = 16;
        public int Size
        {
            get => _Size;
            set
            {
                _Size = value;
                CreateBitmap();
            }
        }

        public Color[][] bitmap;

        public MatrixView()
        {
            InitializeComponent();
        }

        public void CreateBitmap()
        {
            this.bitmap = new Color[_Size][];
            for (int x = 0; x < _Size; x++) 
            {
                this.bitmap[x] = new Color[_Size];
                for (int y = 0; y < _Size; y++)
                    this.bitmap[x][y] = Color.Black;
            }
        }

        public void DrawBitmap()
        {
            Bitmap Gbmp = new Bitmap(_Size, _Size);

            using (Graphics graphics = Graphics.FromImage(Gbmp))
            {
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                for (int x = 0; x < _Size; x++)
                {
                    for (int y = 0; y < _Size; y++)
                    {
                        Gbmp.SetPixel(x, y, this.bitmap[x][y]);
                    }
                }
            }

            this.pictureBox1.Image = new Bitmap((Image)Gbmp, new Size(pictureBox1.Width, pictureBox1.Height));
        }
    }
}
