# Wizcsv
  Wizcsv是一个用ruby实现的简单高效的csv解析器，具备一定的容错能力。

# 使用说明：
1. 导入Wizcsv类：首先，您需要导入WizCsv类，可以通过以下方式进行导入：   
   require 'wizcsv'
   

2. 使用列子：   
   
   options为以下选项：

    -  file_path ：CSV文件的路径（必需）。
    -  col_sep ：列分隔符，默认为逗号。
    -  row_sep ：行分隔符，默认为换行符。
    -  quote_char ：引号字符，默认为双引号。
    -  comment ：注释字符，默认为井号。
    -  chunk_size ：块大小，默认为500。
    -  file_encoding ：文件编码，默认为UTF-8。

   Wizcsv.parse(options) do |rows, csv|
     p rows
   end
   在块中，您可以处理每一行的数据。 rows 参数是一个数组，包含解析后的行数据。 csv 参数是实例对像。

