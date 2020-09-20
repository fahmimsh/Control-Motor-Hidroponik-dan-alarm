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
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }

        private void Form3_Load(object sender, EventArgs e)
        {
            String[] portlist = System.IO.Ports.SerialPort.GetPortNames();
            foreach (String portName in portlist)
                comboBox1.Items.Add(portName);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                serialPort1.PortName = comboBox1.Text;
                serialPort1.Open();
            }
            catch { }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            serialPort1.Close();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            serialPort1.Write("F");
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            serialPort1.Write("G");
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
            serialPort1.Write("H");
        }

        private void button5_Click(object sender, EventArgs e)
        {

        }
    }
}
