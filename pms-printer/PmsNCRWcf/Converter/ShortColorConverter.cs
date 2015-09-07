using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using PmsNCRWcf.Config;

namespace PmsNCRWcf.Converter
{
    public class ShortColorConverter
    {
        public static List<string> Converts(string colors)
        {
            colors = colors + "#";
            List<string> colorList = new List<string>();
            if (!string.IsNullOrEmpty(colors))
            {
                int startIndex = 0;
                for (int i = 0; i < colors.Length; i++)
                {
                    string color = string.Empty;

                    if (i == colors.Length - 1)
                    {
                        colorList.Add(Convert(colors.Substring(startIndex, i - startIndex)));
                    }
                    else
                    {
                        color = Convert(colors.Substring(startIndex, i - startIndex + 1));
                        if (color == null)
                        {
                            string cc = Convert(colors.Substring(startIndex, i - startIndex));
                            if (cc == null)
                            { break; }
                            else
                            {
                                colorList.Add(cc);
                            };
                            startIndex = i;
                            i -= 1;
                        }
                    }
                }
            }
            if (colorList.Count == 0)
            {
                colorList = null;
            }
            return colorList;
        }

        public static string Convert(string color)
        {
            try
            {
                if (ColorConfig.Colors[color] != null)
                {
                    return ColorConfig.Colors[color].ToString();
                }
            }
            catch (Exception e)
            {
                return null;
            }
            return null;
        }
    }
}
