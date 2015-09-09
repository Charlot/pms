class BlueKanbanTimeRule

  def self.get_process_types param
    process_types = []
    case param
      when '2020'
        process_types = ["UlmerWSM60E", "cut pipe machine", "ZDQG-6600"]
      when '2110'
        process_types = ["Inter tool strip box", "KAPPA240"]
      when '2115'
        process_types = ["Inter tool strip box", "KAPPA240"]
      when '2116'
        process_types = ["Inter tool strip box"]
      when '2120'
        process_types = ["Handing Work"]
      when '2150'
        process_types = ["Schleuniger"]   #["Handing Work", "Schleuniger"]
      when '2151'
        process_types = ["Handing Work"]
      when '2160'
        process_types = ["Twisting machine 2HL-8E"]
      when '2165'
        process_types = ["Twisting machine LD"]
      when '2170'
        process_types = ["Handing Work"]

      when '2200'
        process_types = ["pneumatic crimping machine"]
      when '2205'
        process_types = []
      when '2207'
        process_types = ["pneumatic crimping machine"]
      when '2208'
        process_types = ["pneumatic crimping machine"]
      when '2209'
        process_types = ["pneumatic crimping machine", "Handing Work"]
      when '2210'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2211'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2212'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]

      when '2220'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2221'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2222'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2240'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '2250'
        process_types = ["Handing Work", "pneumatic crimping machine"]
      when '2251'
        process_types = ["Handing Work", "pneumatic crimping machine"]
      when '2300'
        process_types = []
      when '2301'
        process_types = []

      when '2410'
        process_types = ["Splice crimping"]
      when '2411'
        process_types = ["pneumatic crimping machine"]#["Splice crimping"]
      when '5200'
        process_types = ["Handing Work"]
      when '5201'
        process_types = ["Handing Work"]
      when '5202'
        process_types = ["Handing Work", "put on PVC pipe"]
      when '5205'
        process_types = ["Handing Work"]
      when '5210'
        process_types = ["UlmerWSM60E", "cut pipe machine", "ZDQG-6600"]
      when '5300'
        process_types = ["put on PVC pipe"]

      when '5320'
        process_types = ["Handing Work"]
      when '5400'
        process_types = ["Handing Work"]
      when '5410'
        process_types = ["Handing Work"]
      when '5420'
        process_types = ["Handing Work"]
      when '5600'
        process_types = ["Handing Work"]

      else
        process_types = []
    end
  end


  def self.get_blue_kanban_process_enrity_time params

    puts '----------------------------------------get_blue_kanban_process_enrity_time------------------------------------------'
    puts params
    process_enrity_time = 0.000

    if params[:process_type] == 'Schleuniger'
      #Schleuniger 9600
      if params[:description] = 'only cutting'
        if (0...1000).include? params[:detail].to_i
          process_enrity_time = 0.109
        elsif (1000...2000).include? params[:detail].to_i
          process_enrity_time = 0.142
        elsif (2000...3000).include? params[:detail].to_i
          process_enrity_time = 0.165
        elsif (3000...4000).include? params[:detail].to_i
          process_enrity_time = 0.194
        elsif (4000..5500).include? params[:detail].to_i
          process_enrity_time = 0.212
        elsif params[:detail].to_i > 5500
          process_enrity_time = 0.233
        end

      elsif params[:description] = 'strip with same knife'
        if (0...1000).include? params[:detail].to_i
          process_enrity_time = 0.193
        elsif (1000...2000).include? params[:detail].to_i
          process_enrity_time = 0.220
        elsif (2000...3000).include? params[:detail].to_i
          process_enrity_time = 0.251
        elsif (3000...4000).include? params[:detail].to_i
          process_enrity_time = 0.278
        elsif (4000..5500).include? params[:detail].to_i
          process_enrity_time = 0.351
        elsif params[:detail].to_i > 5500
          process_enrity_time = 0.400
        end

      elsif params[:description] = 'corrugation pipe cutting'
        if (0...1000).include? params[:detail].to_i
          process_enrity_time = 0.200
        elsif (1000...2000).include? params[:detail].to_i
          process_enrity_time = 0.227
        elsif (2000...3000).include? params[:detail].to_i
          process_enrity_time = 0.258
        elsif (3000...4000).include? params[:detail].to_i
          process_enrity_time = 0.285
        elsif (4000..5500).include? params[:detail].to_i
          process_enrity_time = 0.302
        elsif params[:detail].to_i > 5500
          process_enrity_time = 0.373
        end

      end

    elsif params[:process_type] == 'UlmerWSM60E' && params[:description] == 'corrugation pipe cutting'
      #波纹管切割机 Ulmer WSM60E
      if (0...100).include? params[:detail].to_i
        process_enrity_time = 0.034
      elsif (100...300).include? params[:detail].to_i
        process_enrity_time = 0.056
      elsif (300...500).include? params[:detail].to_i
        process_enrity_time = 0.066
      elsif (500...700).include? params[:detail].to_i
        process_enrity_time = 0.077
      elsif (700..900).include? params[:detail].to_i
        process_enrity_time = 0.109
      elsif (900...1100).include? params[:detail].to_i
        process_enrity_time = 0.117
      elsif (1100..1300).include? params[:detail].to_i
        process_enrity_time = 0.125
      elsif params[:detail].to_i > 1300
        process_enrity_time = 0.135
      end

    elsif params[:process_type] == 'ZDQG-6600' && params[:description] == 'corrugation pipe cutting'
      #波纹管切割机 ZDQG-6600
      if (0...100).include? params[:detail].to_i
        process_enrity_time = 0.020
      elsif (100...300).include? params[:detail].to_i
        process_enrity_time = 0.050
      elsif (300...500).include? params[:detail].to_i
        process_enrity_time = 0.090
      elsif (500...700).include? params[:detail].to_i
        process_enrity_time = 0.130
      elsif (700..900).include? params[:detail].to_i
        process_enrity_time = 0.170
      elsif (900...1100).include? params[:detail].to_i
        process_enrity_time = 0.210
      elsif (1100..1300).include? params[:detail].to_i
        process_enrity_time = 0.241
      elsif params[:detail].to_i > 1300
        process_enrity_time = 0.301
      end

    elsif params[:process_type] == 'KAPPA240' && params[:description] == 'strip 2 side'
      #KAPPA240
      if (0...1000).include? params[:detail].to_i
        process_enrity_time = 0.061
      elsif (1000...2000).include? params[:detail].to_i
        process_enrity_time = 0.076
      elsif (2000...3000).include? params[:detail].to_i
        process_enrity_time = 0.076
      elsif (3000...4000).include? params[:detail].to_i
        process_enrity_time = 0.110
      elsif (4000..5000).include? params[:detail].to_i
        process_enrity_time = 0.126
      elsif (5000...6000).include? params[:detail].to_i
        process_enrity_time = 0.143
      elsif (6000...7000).include? params[:detail].to_i
        process_enrity_time = 0.158
      elsif (7000...8000).include? params[:detail].to_i
        process_enrity_time = 0.175
      elsif (8000..10000).include? params[:detail].to_i
        process_enrity_time = 0.209
      elsif (10000...12000).include? params[:detail].to_i
        process_enrity_time = 0.239
      elsif (12000..14000).include? params[:detail].to_i
        process_enrity_time = 0.272
      elsif params[:detail].to_i > 14000
        process_enrity_time = 0.313
      end

    elsif params[:process_type] == 'Splice crimping'
      if params[:detail] == 'wire length is less than 1.5m'
        if params[:description] == '2 pcs wire'
          process_enrity_time = 0.194
        elsif params[:description] == '3 pcs wire'
          process_enrity_time = 0.255
        elsif params[:description] == '4 pcs wire'
          process_enrity_time = 0.297
        elsif params[:description] == '5 pcs wire'
          process_enrity_time = 0.340
        elsif params[:description] == '6 pcs wire'
          process_enrity_time = 0.382
        elsif params[:description] == '7 pcs wire'
          process_enrity_time = 0.425
        elsif params[:description] == '8 pcs wire'
          process_enrity_time = 0.468
        elsif params[:description] == '9 pcs wire'
          process_enrity_time = 0.510
        elsif params[:description] == '10 pcs wire'
          process_enrity_time = 0.553
        elsif params[:description] == '11 pcs wire'
          process_enrity_time = 0.595
        elsif params[:description] == '12 pcs wire'
          process_enrity_time = 0.638
        elsif params[:description] == '13 pcs wire'
          process_enrity_time = 0.681
        elsif params[:description] == '14 pcs wire'
          process_enrity_time = 0.723
        end

      elsif params[:detail] == '1 side wire length is more than 1.5m'
        if params[:description] == '2 pcs wire'
          process_enrity_time = 0.300
        elsif params[:description] == '3 pcs wire'
          process_enrity_time = 0.343
        elsif params[:description] == '4 pcs wire'
          process_enrity_time = 0.385
        elsif params[:description] == '5 pcs wire'
          process_enrity_time = 0.428
        elsif params[:description] == '6 pcs wire'
          process_enrity_time = 0.470
        elsif params[:description] == '7 pcs wire'
          process_enrity_time = 0.513
        elsif params[:description] == '8 pcs wire'
          process_enrity_time = 0.555
        elsif params[:description] == '9 pcs wire'
          process_enrity_time = 0.598
        elsif params[:description] == '10 pcs wire'
          process_enrity_time = 0.641
        elsif params[:description] == '11 pcs wire'
          process_enrity_time = 0.683
        elsif params[:description] == '12 pcs wire'
          process_enrity_time = 0.726
        elsif params[:description] == '13 pcs wire'
          process_enrity_time = 0.768
        elsif params[:description] == '14 pcs wire'
          process_enrity_time = 0.811
        end

      elsif params[:detail] == '2 sides wire length are more than 1.5m'
        if params[:description] == '2 pcs wire'
          process_enrity_time = 0.406
        elsif params[:description] == '3 pcs wire'
          process_enrity_time = 0.448
        elsif params[:description] == '4 pcs wire'
          process_enrity_time = 0.490
        elsif params[:description] == '5 pcs wire'
          process_enrity_time = 0.532
        elsif params[:description] == '6 pcs wire'
          process_enrity_time = 0.574
        elsif params[:description] == '7 pcs wire'
          process_enrity_time = 0.616
        elsif params[:description] == '8 pcs wire'
          process_enrity_time = 0.658
        elsif params[:description] == '9 pcs wire'
          process_enrity_time = 0.700
        elsif params[:description] == '10 pcs wire'
          process_enrity_time = 0.742
        elsif params[:description] == '11 pcs wire'
          process_enrity_time = 0.784
        elsif params[:description] == '12 pcs wire'
          process_enrity_time = 0.826
        elsif params[:description] == '13 pcs wire'
          process_enrity_time = 0.868
        elsif params[:description] == '14 pcs wire'
          process_enrity_time = 0.910
        end

      end

    elsif params[:process_type] == 'put on PVC pipe'
      process_enrity_time = 0.050

      ######################气动压接机
    elsif params[:process_type] == 'pneumatic crimping machine'
      if params[:description] == 'single wire and seal'
        if params[:detail] == '2T/8T-continuous terminal'
          process_enrity_time = 0.216
        end

      elsif params[:description] == 'single wire'
        if params[:detail] == 'continuous terminal-general crimping'
          process_enrity_time = 0.075
        elsif params[:detail] == 'Continuous terminal-crimping with header'
          process_enrity_time = 0.094
        elsif params[:detail] == 'continuous terminal-several terminal crimping(more than 3 pcs)'
          process_enrity_time = 0.148
        elsif params[:detail] == '8T-scattered terminal'
          process_enrity_time = 0.170
        elsif params[:detail] == '20T/25T-scattered terminal'
          process_enrity_time = 0.220
        end

      elsif params[:description] == 'double wires'
        if params[:detail] == '2T/8T-continuous terminal'
          process_enrity_time = 0.213
        elsif params[:detail] == '8T-scattered terminal'
          process_enrity_time = 0.240
        elsif params[:detail] == '20T/25T-scattered terminal'
          process_enrity_time = 0.287
        elsif params[:detail] == 'Scattered terminal with header'
          process_enrity_time = 0.217
        end

      elsif params[:description] == 'several wires'
        if params[:detail] == '2T/8T-continuous terminal'
          process_enrity_time = 0.225
        elsif params[:detail] == '8T-scattered terminal'
          process_enrity_time = 0.310
        elsif params[:detail] == '20T/25T-scattered terminal'
          process_enrity_time = 0.351
        end

      end

      ###############断管机
    elsif params[:process_type] == 'cut pipe machine'
      if params[:description] == 'PVC pipe/Shrinking pipe'
        if (0...60).include? params[:detail].to_i
          process_enrity_time = 0.041
        elsif (60...300).include? params[:detail].to_i
          process_enrity_time = 0.052
        elsif (300...600).include? params[:detail].to_i
          process_enrity_time = 0.086
        elsif params[:detail].to_i > 600
          process_enrity_time = 0.100
        end
      end

      ########################自动切海绵胶
    elsif params[:process_type] == 'Auto cut sponge machine'
      if params[:description] == 'sponge'
        process_enrity_time = 0.105
      end

      #######################剥线盒
    elsif params[:process_type] == 'Inter tool strip box'
      if params[:description] == 'Strip'
        process_enrity_time = 0.034
      end

      #################热风枪   吹热缩机 Hot wind
    elsif params[:process_type] == 'Hot wind gun' || params[:process_type] == 'Hot wind'
      if params[:description] == 'Melt the pipe'
        if params[:detail] == 'RBK-1'
          process_enrity_time = 0.185
        elsif params[:detail] == 'RBK-2'
          process_enrity_time = 0.218
        elsif params[:detail] == 'RBK-3'
          process_enrity_time = 0.251
        elsif params[:detail] == 'Common pipe'
          process_enrity_time = 0.202
        elsif params[:detail] == 'pipe with glue'
          process_enrity_time = 0.380
        elsif params[:detail] == 'long pipe'
          process_enrity_time = 0.663
        end
      end

      ###############绞线机(LD)
    elsif params[:process_type] == 'Twisting machine LD'
      if params[:description] == 'Twisting'
        if (0...2000).include? params[:detail].to_i
          process_enrity_time = 0.326
        elsif (2000...4000).include? params[:detail].to_i
          process_enrity_time = 0.586
        elsif (4000...6000).include? params[:detail].to_i
          process_enrity_time = 0.798
        elsif params[:detail].to_i > 6000
          process_enrity_time = 1.098
        end
      end

      ###############绞线机(2HL-8E)
    elsif params[:process_type] == 'Twisting machine 2HL-8E'
      if params[:description] == 'Twisting(2 wires)'
        if (0...2000).include? params[:detail].to_i
          process_enrity_time = 0.186
        elsif (2000...4000).include? params[:detail].to_i
          process_enrity_time = 0.245
        elsif (4000...6000).include? params[:detail].to_i
          process_enrity_time = 0.304
        elsif params[:detail].to_i > 6000
          process_enrity_time = 0.363
        end
      elsif params[:description] == 'Twisting(3 wires,Local)'
        if (0...2000).include? params[:detail].to_i
          process_enrity_time = 0.214
        elsif (2000...4000).include? params[:detail].to_i
          process_enrity_time = 0.284
        end
      end

      #################手工工艺
    elsif params[:process_type] == 'Handing Work'
      if params[:description] == 'Shiled wire'
        if params[:detail] == 'peel off'
          process_enrity_time = 0.619
        elsif params[:detail] == 'Order the wire'
          process_enrity_time = 0.350
        elsif params[:detail] == 'cut the wire'
          process_enrity_time = 0.147
        elsif params[:detail] == 'Insert the shrinking pipe'
          process_enrity_time = 0.258
        elsif params[:detail] == 'Shrink the pipe'
          process_enrity_time = 0.380
        end
      elsif params[:description] == 'Insert the seal'
        process_enrity_time = 0.089
      elsif params[:description] == 'Pull on the pipe'
        if (0...200).include? params[:detail].to_i
          process_enrity_time = 0.220
        elsif (200..700).include? params[:detail].to_i
          process_enrity_time = 0.477
        end
      elsif params[:description] == 'Sort the wire'
        if (0...3000).include? params[:detail].to_i
          process_enrity_time = 0.274
        elsif params[:detail].to_i > 3000
          process_enrity_time = 0.324
        elsif params[:detail] == 'section >= 10mm2,L =3000±300mm'
          process_enrity_time = 0.388
        end
      elsif params[:description] == 'Hand cut the PVC pipe'
        process_enrity_time = 0.174
      elsif params[:description] == 'Splice taping'
        if params[:detail] == '2 wires section gap less than 1mm'
          process_enrity_time = 0.211
        elsif params[:detail] == '2 wires section gap more than 1mm'
          process_enrity_time = 0.250
        end
      elsif params[:description] == 'Belt Shrinking manual work'
        if params[:detail] == 'Put through pipe'
          process_enrity_time = 0.048
        elsif params[:detail] == 'Load & unload wires'
          process_enrity_time = 0.138
        elsif params[:detail] == 'put on pipe and melt glue(shield wire)'
          process_enrity_time = 0.220
        elsif params[:detail] == 'load and unload(shield wire)'
          process_enrity_time = 0.113
        end
      elsif params[:description] == 'cut wire and sort the wire'
        if params[:detail] == 'for RBA'
          process_enrity_time = 0.767
        end
      end

    end

    process_enrity_time.round(3)
  end
end