using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace AMAE
{
    public partial class Form1 : Form
    {
        private int _Size = 16;
        public int Size
        {
            get { return _Size; }
            set { _Size = value; CreateBitmap(); }
        }

        Dictionary<int, Color[][]> bitmaps = new Dictionary<int, Color[][]>();
        bool mouseDownState = false;
        int selectX = 0, selectY = 0;
        Color SelectColor = Color.White;
        int selectFrame = 1;

        public Form1()
        {
            InitializeComponent();

            listView1.Columns.Add(new ColumnHeader() { Text = "Кадр", Width = 180 });
            listView1.Items.Clear();
            Text = selectFrame.ToString();

            CreateBitmap();
        }

        public void CreateBitmap()
        {
            selectFrame = bitmaps.Count + 1;
            listView1.Items.Add(new ListViewItem($"Кадр {selectFrame}") { Tag = selectFrame });
            if (selectFrame == 1) bitmaps.Add(selectFrame, new Color[_Size][]);
            else { bitmaps.Add(selectFrame, CreateBitmapTry(bitmaps[selectFrame - 1])); return; }
            
            for (int x = 0; x < _Size; x++)
            {
                this.bitmaps[selectFrame][x] = new Color[_Size];
                for (int y = 0; y < _Size; y++)
                    this.bitmaps[selectFrame][x][y] = Color.Black;
            }
        }

        public Color[][] CreateBitmapTry(Color[][] instance)
        {
            Color[][] outputValue = new Color[_Size][];

            for (int x = 0; x < _Size; x++)
            {
                outputValue[x] = new Color[_Size];
                for (int y = 0; y < _Size; y++)
                    outputValue[x][y] = Color.FromArgb(instance[x][y].ToArgb());
            }

            return outputValue;
        }

        public void DrawBitmap()
        {
            Bitmap Gbmp = new Bitmap(_Size, _Size);

            using (Graphics graphics = Graphics.FromImage(Gbmp))
            {
                graphics.InterpolationMode = InterpolationMode.NearestNeighbor;
                for (int x = 0; x < _Size; x++)
                {
                    for (int y = 0; y < _Size; y++)
                    {
                        Gbmp.SetPixel(x, y, this.bitmaps[selectFrame][x][y]);
                    }
                }
            }

            Bitmap outBitmap = DrawZoomBitMap(Gbmp, pictureBox1.Width / _Size);
            int coefficient = (pictureBox1.Width / _Size);
            // draw select pixel:
            using (Graphics g = Graphics.FromImage(outBitmap))
            {
                if (selectX >= _Size || selectY >= _Size ||
                    selectX < 0 || selectY < 0) return;
                g.DrawRectangle(new Pen(new SolidBrush(Color.White), 2),
                    new Rectangle(selectX * coefficient, selectY * coefficient, pictureBox1.Width / _Size, pictureBox1.Width / _Size));
            }

            this.pictureBox1.Image = outBitmap;
        }

        public Bitmap DrawZoomBitMap(Bitmap bmp, float zoom)
        {
            Bitmap zoomed;

            zoomed = new Bitmap((int)(bmp.Size.Width * zoom), (int)(bmp.Size.Height * zoom));

            using (Graphics g = Graphics.FromImage(zoomed))
            {
                g.InterpolationMode = InterpolationMode.NearestNeighbor;
                g.PixelOffsetMode = PixelOffsetMode.Half;

                g.DrawImage(bmp, new Rectangle(Point.Empty, zoomed.Size));
            }

            return zoomed;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            DrawBitmap();
            if (mouseDownState && selectX < _Size && selectY < _Size &&
                selectX >= 0 && selectY >= 0) bitmaps[selectFrame][selectX][selectY] = SelectColor;
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            int coefficient = (pictureBox1.Width / _Size);
            selectX = (e.X / coefficient);
            selectY = (e.Y / coefficient);

            // draw select pixel:
            /*using (Graphics g = this.pictureBox1.CreateGraphics())
            {
                if (selectX >= _Size || selectY >= _Size) return;
                g.DrawRectangle(new Pen(new SolidBrush(Color.White), 2),
                    new Rectangle(selectX * coefficient, selectY * coefficient, pictureBox1.Width / _Size, pictureBox1.Width / _Size));
            }*/
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
        {
            mouseDownState = false;
        }

        private void pictureBox1_MouseLeave(object sender, EventArgs e)
        {
            mouseDownState = false;
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            mouseDownState = true;
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            DialogResult dialog = colorDialog1.ShowDialog();

            if (dialog == DialogResult.OK) 
            {
                SelectColor = colorDialog1.Color;
                pictureBox2.BackColor = colorDialog1.Color;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listView1.SelectedItems.Count <= 0) return;
            this.selectFrame = (int)listView1.SelectedItems[0].Tag;
            Text = selectFrame.ToString();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            CreateBitmap();
        }
    }
}
