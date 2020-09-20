using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GUI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            String[] portlist = System.IO.Ports.SerialPort.GetPortNames();
            foreach (String portName in portlist)
                comboBox1.Items.Add(portName);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            serialPort1.Write("A");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            serialPort1.Write("B");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            serialPort1.Write("D");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            serialPort1.Write("C");
        }

        private void button7_Click(object sender, EventArgs e)
        {
            serialPort1.Write("E");
        }

        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                serialPort1.PortName = comboBox1.Text;
                serialPort1.Open();
            }
            catch { }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            serialPort1.Close();
        }

        private void serialPort1_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            try
            {
                String receiveMsg = serialPort1.ReadLine();
                Tampilkan(receiveMsg);
            }
            catch { }
        }

        private delegate void TampilkanDelegate(object item);
        private void Tampilkan(object item)
        {
            if (InvokeRequired)
                textBox1.Invoke(new TampilkanDelegate(Tampilkan), item);
            else
            {
                textBox1.Text = Convert.ToString(item);
            }
        }
    }
}
