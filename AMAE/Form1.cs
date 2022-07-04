using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Windows.Forms;
using System.Threading;
using System.Net;
using System.IO;

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
        string matrixIP = "http://192.168.1.36:8888/";
        bool mouseDownState = false;
        int selectX = 0, selectY = 0;
        Color SelectColor = Color.White;
        int selectFrame = 1;
        bool MatrixStream = true;
        bool MatrixStreamLoop = false;

        public Form1()
        {
            InitializeComponent();

            listView1.Columns.Add(new ColumnHeader() { Text = "Кадр", Width = 180 });
            listView1.Items.Clear();
            Text = selectFrame.ToString();

            CreateBitmap();

            Thread matrixStreamThread = new Thread(MatrixLoop);
            matrixStreamThread.Start();
        }

        public void MatrixLoop()
        {
            UInt64 loopCount = 0;
            Random random = new Random();
            int frame = 1;
            while (MatrixStream) 
            {
                if (!MatrixStreamLoop) continue;
                Console.WriteLine(++loopCount);

                string outputHttpGetValue = matrixIP;
                for (int _x = _Size-1; _x >= 0; _x--)
                {
                    if (_x % 2 != 0)
                        for (int _y = 0; _y < _Size; _y++)
                            outputHttpGetValue += $"{bitmaps[frame][_y][_x].ToArgb()},";
                    else
                        for (int _y = _Size-1; _y >= 0; _y--)
                            outputHttpGetValue += $"{bitmaps[frame][_y][_x].ToArgb()},";
                }
                Console.WriteLine(outputHttpGetValue);
                HttpGet(outputHttpGetValue);

                frame++;
                if (frame > bitmaps.Count) frame = 1;
            }
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

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listView1.SelectedItems.Count <= 0) return;
            this.selectFrame = (int)listView1.SelectedItems[0].Tag;
            Text = selectFrame.ToString();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            MatrixStreamLoop = checkBox1.Checked;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            CreateBitmap();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                saveFileDialog1.Filter = "Bitmaps Data Files (*.bmpsd;*.bmd)|*.bmpsd;*.bmd";
                saveFileDialog1.Title = "Сохранить кадры как";
                DialogResult dialog = saveFileDialog1.ShowDialog();

                if (dialog == DialogResult.OK)
                {
                    BinDataSerialization.Save(bitmaps, saveFileDialog1.FileName);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.StackTrace, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        } // save

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                openFileDialog1.Filter = "Bitmaps Data Files (*.bmpsd;*.bmd)|*.bmpsd;*.bmd";
                saveFileDialog1.Title = "Открыть кадры";
                DialogResult dialog = openFileDialog1.ShowDialog();

                if (dialog == DialogResult.OK)
                {
                    selectFrame = 1;
                    bitmaps = BinDataSerialization.Open(openFileDialog1.FileName);
                    listView1.Items.Clear();
                    foreach (int item in bitmaps.Keys)
                        listView1.Items.Add(new ListViewItem("Кадр " + item) { Tag = item });
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.StackTrace, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        } // open

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                openFileDialog1.Filter = "Image Files(*.BMP;*.JPG;*.PNG)|*.BMP;*.JPG;*.PNG";
                openFileDialog1.Title = "Загрузить изображение";
                openFileDialog1.Multiselect = true;
                DialogResult dialog = openFileDialog1.ShowDialog();

                if (dialog == DialogResult.OK)
                {
                    foreach (string item in openFileDialog1.FileNames)
                    {
                        Image img = Image.FromFile(item);
                        Bitmap bmp = new Bitmap(img, new Size(_Size, _Size));
                        Color[][] bmpFrame = new Color[_Size][];
                        for (int i = 0; i < _Size; i++)
                            bmpFrame[i] = new Color[_Size];

                        for (int x = 0; x < _Size; x++)
                            for (int y = 0; y < _Size; y++)
                                bmpFrame[x][y] = bmp.GetPixel(x, y);

                        selectFrame = bitmaps.Count + 1;
                        listView1.Items.Add(new ListViewItem($"Кадр {selectFrame}") { Tag = selectFrame });
                        bitmaps.Add(selectFrame, bmpFrame);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.StackTrace, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        } // image import

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            this.MatrixStream = false;
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            matrixIP = textBox1.Text;
        }

        private bool useColor = false;
        private void p_red_TextChanged(object sender, EventArgs e)
        {
            if (useColor) return;

            try
            {
                useColor = true;

                int red = Convert.ToInt32(p_red.Text);

                this.SelectColor = Color.FromArgb(red, this.SelectColor.G, this.SelectColor.B);
                this.p_dec.Text = this.SelectColor.ToArgb().ToString();
                this.p_hex.Text = HexConverter(this.SelectColor);

                this.pictureBox2.BackColor = this.SelectColor;
            }
            catch (Exception ex)
            {
                p_red.Text = this.SelectColor.R.ToString();
            }

            useColor = false;
        }

        private void p_green_TextChanged(object sender, EventArgs e)
        {
            if (useColor) return;

            try
            {
                useColor = true;

                int green = Convert.ToInt32(p_green.Text);

                this.SelectColor = Color.FromArgb(this.SelectColor.R, green, this.SelectColor.B);
                this.p_dec.Text = this.SelectColor.ToArgb().ToString();
                this.p_hex.Text = HexConverter(this.SelectColor);

                this.pictureBox2.BackColor = this.SelectColor;
            }
            catch (Exception ex)
            {
                p_green.Text = this.SelectColor.G.ToString();
            }

            useColor = false;
        }

        private void p_blue_TextChanged(object sender, EventArgs e)
        {
            if (useColor) return;

            try
            {
                useColor = true;

                int blue = Convert.ToInt32(p_blue.Text);

                this.SelectColor = Color.FromArgb(this.SelectColor.R, this.SelectColor.G, blue);
                this.p_dec.Text = this.SelectColor.ToArgb().ToString();
                this.p_hex.Text = HexConverter(this.SelectColor);

                this.pictureBox2.BackColor = this.SelectColor;
            }
            catch (Exception ex)
            {
                p_blue.Text = this.SelectColor.B.ToString();
            }

            useColor = false;
        }

        private void p_dec_TextChanged(object sender, EventArgs e)
        {
            if (useColor) return;

            try
            {
                useColor = true;

                int dec = Convert.ToInt32(p_dec.Text);

                this.SelectColor = Color.FromArgb(dec);
                this.p_red.Text = this.SelectColor.R.ToString();
                this.p_green.Text = this.SelectColor.G.ToString();
                this.p_blue.Text = this.SelectColor.B.ToString();
                this.p_hex.Text = HexConverter(this.SelectColor);

                this.pictureBox2.BackColor = this.SelectColor;
            }
            catch (Exception ex)
            {
                p_dec.Text = this.SelectColor.ToArgb().ToString();
            }

            useColor = false;
        }

        private void p_hex_TextChanged(object sender, EventArgs e)
        {
            if (useColor) return;

            try
            {
                useColor = true;

                Color color = (Color)new ColorConverter().ConvertFromString(p_hex.Text);

                this.SelectColor = color;
                this.p_red.Text = this.SelectColor.R.ToString();
                this.p_green.Text = this.SelectColor.G.ToString();
                this.p_blue.Text = this.SelectColor.B.ToString();
                this.p_dec.Text = this.SelectColor.ToArgb().ToString();
                

                this.pictureBox2.BackColor = this.SelectColor;
            }
            catch (Exception ex)
            {
                p_hex.Text = HexConverter(this.SelectColor);
            }

            useColor = false;
        }

        private static string HttpGet(string URI)
        {
            try
            {
                WebClient client = new WebClient();

                client.Headers.Add("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");

                Stream data = client.OpenRead(URI);
                StreamReader reader = new StreamReader(data);
                string s = reader.ReadToEnd();
                data.Close();
                reader.Close();

                return s;
            }
            catch
            {
                return "#nodata";
            }
        }

        private static String HexConverter(System.Drawing.Color c)
        {
            return "#" + c.R.ToString("X2") + c.G.ToString("X2") + c.B.ToString("X2");
        }

        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                openFileDialog1.Filter = "Gif File(*.GIF)|*.GIF";
                openFileDialog1.Title = "Загрузить gif изображение";
                DialogResult dialog = openFileDialog1.ShowDialog();

                if (dialog == DialogResult.OK)
                {
                    foreach (Image img in getFrames(Image.FromFile(openFileDialog1.FileName)))
                    {
                        Bitmap bmp = new Bitmap(img, new Size(_Size, _Size));
                        Color[][] bmpFrame = new Color[_Size][];
                        for (int i = 0; i < _Size; i++)
                            bmpFrame[i] = new Color[_Size];

                        for (int x = 0; x < _Size; x++)
                            for (int y = 0; y < _Size; y++)
                                bmpFrame[x][y] = bmp.GetPixel(x, y);

                        selectFrame = bitmaps.Count + 1;
                        listView1.Items.Add(new ListViewItem($"Кадр {selectFrame}") { Tag = selectFrame });
                        bitmaps.Add(selectFrame, bmpFrame);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.StackTrace, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        } // gif import 

        private static String RGBConverter(System.Drawing.Color c)
        {
            return "RGB(" + c.R.ToString() + "," + c.G.ToString() + "," + c.B.ToString() + ")";
        }

        private void button6_Click(object sender, EventArgs e)
        {

        } // remove frame

        private static Image[] getFrames(Image originalImg)
        {
            int numberOfFrames = originalImg.GetFrameCount(FrameDimension.Time);
            Image[] frames = new Image[numberOfFrames];

            for (int i = 0; i < numberOfFrames; i++)
            {
                originalImg.SelectActiveFrame(FrameDimension.Time, i);
                frames[i] = ((Image)originalImg.Clone());
            }

            return frames;
        }
    }
}
