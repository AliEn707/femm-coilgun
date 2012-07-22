-- ������ ��� ��������� FEMM 4.2 
--------------------------------------------------------------------------------

setcompatibilitymode(1) -- ������������� � ������� 4.2

----[ ������ ��������� ]-----------------------------------------------------------------------------------------------
vers          = 119          -- ������ �������
k_rc          = 140          -- ���������� ��������� RC ��� ��������������� ������������������ �����������, ��*���
coil_meshsize = 0.5          -- ������ ����� �������, ��
proj_meshsize = 0.35         -- ������ ����� ����, ��
max_segm      = 5            -- ������������ ������ �������� ������������, ����
sigma         = 0.0000000175 -- �������� ������������� ����, �� * ����
ro            = 7800         -- ��������� ������, ��/����^3
pi            = 3.1415926535  
name_mat      = "Iron"
coil_name     = "katushka"

----[ ������ ��������� ������ �� ���������� ����� ]--------------------------------------------------------------------
function read_config_file(file_name)
	local config = {}
	local handle = openfile(file_name,"r")
	read(handle, "*l")
	read(handle, "*l")
	read(handle, "*l")
	read(handle, "*l")
	
	config.c       = read(handle, "*n", "*l") -- ������� ������������, ����������
	config.u       = read(handle, "*n", "*l") -- ���������� �� ������������, ����� 
	config.r_sw    = read(handle, "*n", "*l") -- ������������� �����, �� 
	config.d_pr    = read(handle, "*n", "*l") -- ������� ����������� ������� �������, ��������
	config.l_kat   = read(handle, "*n", "*l") -- ����� ������� (�� �������� ������ �������� �����. ������� �������), ��������
	config.d_kat   = read(handle, "*n", "*l") -- ������� ������� �������, ��������
	config.l_mag   = read(handle, "*n", "*l") -- ������� ����� �������� ��������������, �� ����� ��������� �������, ���� ���� �� ��� ���, ��������
	config.l_mag_y = read(handle, "*n", "*l") -- ������� ������ �������� ��������������, ���� 0 �� ����� ������.
	config.k_ark   = read(handle, "*n", "*l") -- ������� ������� �������
	config.k_mot   = read(handle, "*n", "*l") -- ��������� ������� (0,7-0,95) ��� ���������� ������
	config.l_puli  = read(handle, "*n", "*l") -- ����� ����, ��������
	config.d_puli  = read(handle, "*n", "*l") -- ������� ����, ��������
	config.l_otv   = read(handle, "*n", "*l") -- ������� ��������� � ����, �������� 
	config.d_otv   = read(handle, "*n", "*l") -- ������� ��������� � ����, �������� (0 - ���� ��� ���������)
	config.nagr    = read(handle, "*n", "*l") -- ����� �������������� �������� ��� ��������, �����
	config.l_sdv   = read(handle, "*n", "*l") -- ����������, �� ������� � ��������� ������ �������� ���� � ������� ��� ��������� �� ������� � �������, ��������
	config.d_stv   = read(handle, "*n", "*l") -- ������� ������� ������ (�� �������� ������ �������� ����), ��������
	config.vel0    = read(handle, "*n", "*l") -- ��������� �������� ����, �/� (������ 0 ����� �����-�� ��������� ��������, ����� ����� �� ����� �����)
	config.delta_t = read(handle, "*n", "*l") -- ���������� �������, ��� 
	config.mode    = read(handle, "*n", "*l") -- mode 
	
	local t_iz = sqrt(config.d_pr) * 0.07
	config.d_pr_iz = config.d_pr+t_iz -- ������� ������� � ��������
	config.r_cc = (k_rc / config.c) -- ���������� ������������� ������������
	
	-- ������ �� ������ 
	if config.d_stv < config.d_puli then config.d_stv = config.d_puli + 0.1 end 
	if config.l_otv > (config.l_puli-0.5) then config.l_otv = config.l_puli - 0.5 end
	if config.l_otv < 0 then config.l_otv = 0 end
	if config.d_otv > (config.d_puli-0.5) then config.d_otv = config.d_puli - 0.5 end
	if config.d_otv < 0 then config.d_otv = 0 end
	
	-- ������� �� - ����, �����
	config.c       = config.c / 1000000
	config.d_pr    = config.d_pr / 1000
	config.d_pr_iz = config.d_pr_iz / 1000
	config.l_puli  = config.l_puli / 1000
	config.d_puli  = config.d_puli / 1000
	config.l_otv   = config.l_otv / 1000
	config.d_otv   = config.d_otv / 1000
	config.d_stv   = config.d_stv / 1000
	config.l_kat   = config.l_kat / 1000
	config.d_kat   = config.d_kat / 1000
	config.l_sdv   = config.l_sdv / 1000
	config.l_mag   = config.l_mag / 1000
	config.l_mag_y = config.l_mag_y / 1000
	config.nagr    = config.nagr / 1000
	
	return config
end

----[ ��������� ������� ������� ��������� "������ �����" ]-------------------------------------------------------------
function add_iron_material()
	local iron_props = {
		{0,      0       },
		{0.0001, 50      },
		{0.001,  100     },
		{0.01,   150     },
		{0.015,  175     },
		{0.0253, 200     },
		{0.15,   300     },
		{0.5031, 400     },
		{1.0059, 500     },
		{1.3706, 700     },
		{1.4588, 900     },
		{1.51,   1200    },
		{1.55,   1600    },
		{1.58,   2000    },
		{1.62,   2700    },
		{1.77,   10000   },
		{1.84,   20000   },
		{1.93,   42000   },
		{2.01,   75000   },
		{2.10,   123300  },
		{2.25,   207000  },
		{2.439,  350000  },
		{3.13,   900000  },
		{7.65,   4500000 },
		{13.3,   9000000 },
		{22.09,  16000000}
	}

	mi_addmaterial(name_mat,"","","","","",0)        
	for i, prop in iron_props do
		mi_addbhpoint(name_mat, prop[1], prop[2]) 
	end
end

----[ ������ ������ � FEMM ��� �������� ]-----------------------------------------------------------------------------
function create_project(config)
	local Vol = 3 -- ��������� ���������� ������������ ������ ������ (������������� �������� �� 3 �� 5)
	
	local d_otv = config.d_otv * 1000
	local d_kat = config.d_kat * 1000
	local l_kat = config.l_kat * 1000
	local l_mag = config.l_mag * 1000
	local l_mag_y = config.l_mag_y * 1000
	local d_stv = config.d_stv * 1000
	local l_puli = config.l_puli * 1000
	local l_sdv = config.l_sdv * 1000
	local d_puli = config.d_puli * 1000
	local l_otv = config.l_otv * 1000
	local d_pr = config.d_pr * 1000
	
	create(0) -- ������� �������� ��� ��������� �����
	mi_probdef(0,"millimeters","axi",1E-8,30) -- ������� ������
	mi_saveas("temp.fem") -- ��������� ���� ��� ������ ������
	mi_addmaterial("Air",1,1) -- ��������� �������� ������
	mi_addmaterial("Cu",1,1,"","","",58,"","","",3,"","",1,d_pr) -- ��������� �������� ������ ������ ��������� d_pr ������������� 58
	mi_addcircprop(coil_name,0,0,1) -- ��������� ������� 
	add_iron_material()

-- ����������� �������

	--������� ������������ � Vol ��� ������� ��� �������
	mi_addnode(0,(l_kat+l_mag)*-Vol) -- ������ �����
	mi_addnode(0,(l_kat+l_mag)*Vol) -- ������ �����
	mi_addsegment(0,(l_kat+l_mag)*-Vol,0,(l_kat+l_mag)*Vol) -- ������ �����
	mi_addarc(0,(l_kat+l_mag)*-5,0,(l_kat+l_mag)*Vol,180,max_segm) -- ������ ����
	mi_addblocklabel((l_kat+l_mag)*0.7*Vol,0) -- ��������� ����
	mi_clearselected() -- �������� ��� 
	mi_selectlabel((l_kat+l_mag)*0.7*Vol,0) -- �������� ����� �����
	mi_setblockprop("Air", 1, "", "", "",0) -- ������������� �������� ����� � ����� Air � ������� ����� 0
	mi_zoomnatural() -- ������������� ��� ��� ��� �� ���� ����� �� ���� �����

-- ������� ����

-- ���� ����� ���� ����� �������� ������ ���
	if l_puli==d_puli then 
		mi_addnode(0,l_kat/2-l_sdv)
		mi_addnode(0,l_kat/2+l_puli-l_sdv)
		mi_clearselected()
		mi_selectnode (0,l_kat/2-l_sdv)
		mi_selectnode (0,l_kat/2+l_puli-l_sdv)
		mi_setnodeprop("",1)
		mi_addarc(0,l_kat/2-l_sdv,0,l_kat/2+l_puli-l_sdv,180,5)
	-- ����� ������ �������
	else
		mi_addnode(0,l_kat/2-l_sdv)
		mi_addnode(d_puli/2,l_kat/2-l_sdv)
		mi_addnode(d_puli/2,l_kat/2+l_puli-l_sdv)
		-- ����� ��� ��������� � ����
		if d_otv>0 then 
			mi_addnode(0,l_kat/2-l_sdv+l_puli-l_otv) -- ����� ������ �� ������� �����
			mi_addnode(d_otv/2,l_kat/2-l_sdv+l_puli-l_otv) -- ����� ������ ����
			mi_addnode(d_otv/2,l_kat/2+l_puli-l_sdv) -- ����� �� ������� ����
		else
			mi_addnode(0,l_kat/2+l_puli-l_sdv)
		end

		mi_clearselected()
		mi_selectnode(0,l_kat/2-l_sdv)
		mi_selectnode(d_puli/2,l_kat/2-l_sdv) 
		mi_selectnode(d_puli/2,l_kat/2+l_puli-l_sdv)

		if d_otv>0 then
			mi_selectnode(0,l_kat/2-l_sdv+l_puli-l_otv)
			mi_selectnode(d_otv/2,l_kat/2-l_sdv+l_puli-l_otv)
			mi_selectnode(d_otv/2,l_kat/2+l_puli-l_sdv)
		else
			mi_selectnode(0,l_kat/2+l_puli-l_sdv)
		end

		mi_setnodeprop("",1)

		mi_addsegment(d_puli/2,l_kat/2-l_sdv,d_puli/2,l_kat/2+l_puli-l_sdv) -- ������� ����� �����

		if d_otv>0 then 
			mi_addsegment(d_puli/2,l_kat/2+l_puli-l_sdv,d_otv/2,l_kat/2+l_puli-l_sdv) -- ������ �����
		else 
			mi_addsegment(d_puli/2,l_kat/2+l_puli-l_sdv,0,l_kat/2+l_puli-l_sdv) -- ������ �����
		end 
		if d_otv>0 then  
			mi_addsegment(d_otv/2,l_kat/2+l_puli-l_sdv,d_otv/2,l_kat/2-l_sdv+l_puli-l_otv) -- ������ ���������
			mi_addsegment(d_otv/2,l_kat/2-l_sdv+l_puli-l_otv,0,l_kat/2-l_sdv+l_puli-l_otv) -- ��� ���������
			mi_addsegment(0,l_kat/2-l_sdv+l_puli-l_otv,0,l_kat/2-l_sdv) -- ������ ����� ����
		else
			mi_addsegment(0,l_kat/2+l_puli-l_sdv,0,l_kat/2-l_sdv) -- ������ ����� ����
		end 
		mi_addsegment(0,l_kat/2-l_sdv,d_puli/2,l_kat/2-l_sdv) -- �������� ����� 
	end

	mi_addblocklabel(d_puli/4,l_kat/2+l_puli/2-l_otv/2-l_sdv)
	mi_clearselected()
	mi_selectlabel(d_puli/4,l_kat/2+l_puli/2-l_otv/2-l_sdv)
	mi_setblockprop(name_mat, 1, proj_meshsize, "", "",1) -- ����� ����� 1

-- ������� �������
	if (config.k_ark <= 0) then config.k_ark = 0.5 end

	mi_addnode(d_stv/2,l_kat/2) -- ���������
	mi_addnode(d_stv/2,-l_kat/2) -- ���������
	mi_addnode(d_kat/2,l_kat/2) -- ������� ��������� �����
	mi_addnode(d_kat/2,-l_kat/2) -- ������� �������� �����

	mi_addnode(config.k_ark+d_stv/2,-config.k_ark+l_kat/2) -- ���������
	mi_addnode(config.k_ark+d_stv/2,config.k_ark-l_kat/2) -- ���������
	mi_addnode(-config.k_ark+d_kat/2,-config.k_ark+l_kat/2) -- ������� ��������� �����
	mi_addnode(-config.k_ark+d_kat/2,config.k_ark-l_kat/2) -- ������� �������� �����

	mi_addsegment(d_stv/2,-l_kat/2,d_stv/2,l_kat/2)
	mi_addsegment(d_stv/2,l_kat/2,d_kat/2,l_kat/2)
	mi_addsegment(d_kat/2,l_kat/2,d_kat/2,-l_kat/2)
	mi_addsegment(d_kat/2,-l_kat/2,d_stv/2,-l_kat/2)

	mi_addsegment(config.k_ark+d_stv/2,config.k_ark-l_kat/2,config.k_ark+d_stv/2,-config.k_ark+l_kat/2)
	mi_addsegment(config.k_ark+d_stv/2,-config.k_ark+l_kat/2,-config.k_ark+d_kat/2,-config.k_ark+l_kat/2)
	mi_addsegment(-config.k_ark+d_kat/2,-config.k_ark+l_kat/2,-config.k_ark+d_kat/2,config.k_ark-l_kat/2)
	mi_addsegment(-config.k_ark+d_kat/2,config.k_ark-l_kat/2,config.k_ark+d_stv/2,config.k_ark-l_kat/2)

	mi_clearselected()
	mi_selectnode(config.k_ark+d_stv/2,-config.k_ark+l_kat/2) -- ���������
	mi_selectnode(config.k_ark+d_stv/2,config.k_ark-l_kat/2) -- ���������
	mi_selectnode(-config.k_ark+d_kat/2,-config.k_ark+l_kat/2)
	mi_selectnode(-config.k_ark+d_kat/2,config.k_ark-l_kat/2)
	mi_setnodeprop("",2)

	mi_addblocklabel(d_stv/2+(d_kat/2-d_stv/2)/2,0)
	mi_clearselected()
	mi_selectlabel(d_stv/2+(d_kat/2-d_stv/2)/2,0)
	mi_setblockprop("Cu", 0, coil_meshsize, coil_name, "",2) -- ����� ����� 2

	mi_addblocklabel(config.k_ark/2+d_stv/2,-config.k_ark+l_kat/4) -- ��������� ����
	mi_clearselected() -- �������� ��� 
	mi_selectlabel(config.k_ark/2+d_stv/2,-config.k_ark+l_kat/4) -- �������� ����� �����
	mi_setblockprop("Air", 1, coil_meshsize, "", "",4) -- ������������� �������� ����� � ����� Air � ������� ����� 4

-- ������� ������� �������������
	if (l_mag > 0) then 
        if (l_mag_y <=0) then l_mag_y = l_mag end
		mi_addnode(d_stv/2,l_kat/2+l_mag_y)
		mi_addnode(d_kat/2+l_mag,l_kat/2+l_mag_y)
		mi_addnode(d_kat/2+l_mag,-l_kat/2-l_mag_y)	
		mi_addnode(d_stv/2,-l_kat/2-l_mag_y)

		mi_addsegment(d_stv/2,l_kat/2,d_stv/2,l_kat/2+l_mag_y)
		mi_addsegment(d_stv/2,l_kat/2+l_mag_y,d_kat/2+l_mag,l_kat/2+l_mag_y)
		mi_addsegment(d_kat/2+l_mag,l_kat/2+l_mag_y,d_kat/2+l_mag,-l_kat/2-l_mag_y)

		mi_addsegment(d_kat/2+l_mag,-l_kat/2-l_mag_y,d_stv/2,-l_kat/2-l_mag_y)
		mi_addsegment(d_stv/2,-l_kat/2-l_mag_y,d_stv/2,-l_kat/2)

		mi_addblocklabel(d_kat/2+l_mag/2,0)
		mi_clearselected()
		mi_selectlabel(d_kat/2+l_mag/2,0)
		mi_setblockprop(name_mat, 1, "", "", "",3) -- ����� ����� 3

	end
	mi_clearselected()
end

----[ ��������� ������ �������� �� ����������, �������� � config ]-----------------------------------------------------
function simulate(config)
	local result = {}

	-- ��������
	result.start_date = date()

	result.r_v = config.r_sw+config.r_cc -- ������������� ����� + ���������� ������������� ������������, ��

	-- ����������� � ��������� �������������
	mi_analyze(1)                        -- ����������� (������� ���� ������� "1")
	mi_loadsolution()                    -- ��������� ���� ��������� ���� ����������
	mo_groupselectblock(2)
	local Skat = mo_blockintegral(5)     -- ������� ������� �������, ����^2 
	local Vkat = mo_blockintegral(10)    -- ����� �������, ����^3
	mo_clearblock()
	mo_groupselectblock(1)
	local Vpuli = mo_blockintegral(10)   -- ����� ����, ����^3
	mo_clearblock()
	result.m_puli=ro*Vpuli + config.nagr -- ����� ���� ���� ��������, ��

	if config.k_mot < 1 then
		result.n = config.k_mot * Skat / (config.d_pr_iz * config.d_pr_iz) -- ���������� ������ � ������� ���������
	else 
		result.n = config.k_mot -- ��� ���� ������
	end

	local end_x = config.l_puli + config.l_kat - config.l_sdv -- ��������� ���� �� �������� �������

	result.dl_provoda = result.n * 2 * pi * (config.d_kat + config.d_stv) / 4 -- ����� ����������� ������� ���������, �
	result.r_kat = sigma * result.dl_provoda / (pi * (config.d_pr / 2)^2)     -- ������������� ����� ����������� ������� �������, ��
	result.r = result.r_v + result.r_kat                                      -- ������ ������������� �������

	--������������� ����� ������, � ���� ���� 100 � ��� ������ �������������
	mi_clearselected()
	mi_selectlabel(config.d_stv * 1000 / 2 + (config.d_kat / 2 - config.d_stv / 2) * 1000 / 2, 0) 
	mi_setblockprop("Cu", 0, coil_meshsize, coil_name, "", 2, result.n) -- ��������� �������� - ����� ������
	mi_clearselected()
	mi_modifycircprop(coil_name, 1, 100)

	-- ����������� � ��������� �������������
	mi_analyze(1)                                                   -- ����������� (������� ���� ������� "1")
	mo_reload()                                                     -- ������������� ��������� ���� ����������
	current_re,_,_,_,flux_re,_ = mo_getcircuitproperties(coil_name) -- �������� ������ � �������
	result.l = flux_re / current_re                                 -- ��������� �������������, �����

	-- ������ ���������
	local dt = config.delta_t / 1000000 -- ������� ���������� ������� � ������� 
	local x = 0                         -- ��������� ������� ����
	local I0 = 0.01                     -- ���������� ����� �������� ����  I0=0.01
	local Uc = config.u
	local I = I0                        -- ��������� �������� ����
	local Force = 0
	local Fii = 0
	local Fix = 0
	local kc = 1                        -- ������� ������, ��� ������� ������ � ������ result.items

	result.v_max = config.vel0
	result.f_aver = 0
	result.t = 0                        -- ����� �����
	result.vel = config.vel0
	result.items = {}                   -- ������� ������ (������� ��� � �������� � Lua)

	repeat -- �������� ����
		result.t = result.t+dt

		--- ������������ dFi/dI ��� I � ����
		mi_modifycircprop(coil_name, 1, I)                     -- ������������� ��� 
		mi_analyze(1)                                          -- ����������� (������� ���� ������� "1")
		mo_reload()                                            -- ������������� ��������� ���� ����������
		mo_groupselectblock(1)
		Force = mo_blockintegral(19)                           -- ���� ����������� �� ����, ������	
		Force = Force * -1                                     -- ������ "-" �� �� ��������� (����������� ���� � ������� ���������� ����������)
		result.f_aver = result.f_aver + Force * dt
		_,_,_,_,flux_re,_ = mo_getcircuitproperties(coil_name) -- �������� ������ � �������
		local Fi0=flux_re                                      -- ��������� �����

		mi_modifycircprop(coil_name, 1, I * 1.001)             -- ������������� ���, ����������� �� 1.001
		mi_analyze(1)                                          -- ����������� (������� ���� ������� "1")
		mo_reload()                                            -- ������������� ��������� ���� ����������
		_,_,_,_,flux_re,_ = mo_getcircuitproperties(coil_name) -- �������� ������ � �������
		local Fi1 = flux_re                                    -- ��������� ����� ��� I=I+0.001*I, dI=0.001*I 
		Fii = (Fi1 - Fi0) / (0.001 * I)                        -- ������������ dFi/dI

		local apuli = Force / result.m_puli                    -- ��������� ����, ����/�������^2 
		local dx = result.vel * dt                             -- ���������� ����������, ���� (�����������)
		x = x + dx                                             -- ����� ������� ����
		result.vel = result.vel + apuli * dt                   -- �������� ����� ����������, ����/�������
		if result.v_max < result.vel then result.v_max = result.vel end

		mi_selectgroup(1)                                      -- �������� ����
		mi_movetranslate(0, -dx * 1000)                        -- ���������� � �� dx
		mi_modifycircprop(coil_name, 1, I)                     -- ������������� ��� 
		mi_analyze(1)                                          -- ����������� (������� ���� ������� "1")
		mo_reload()                                            -- ������������� ��������� ���� ����������
		mo_groupselectblock(1)
		_,_,_,_,flux_re,_ = mo_getcircuitproperties(coil_name) -- �������� ������ � �������
		local Fi0 = flux_re                                    -- ��������� �����

		mi_modifycircprop(coil_name, 1 , I * 1.001)            -- ������������� ���, ����������� �� 1.001
		mi_analyze(1)                                          -- ����������� (������� ���� ������� "1")
		mo_reload()                                            -- ������������� ��������� ���� ����������
		_,_,_,_,flux_re,_ = mo_getcircuitproperties(coil_name) -- �������� ������ � �������
		Fi1 = flux_re                                          -- ��������� ����� ��� I=I+0.001*I, dI=0.001*I 

		-- ������������ dFi/dI
		Fif = (Fi1 - Fi0) / (0.001 * I)                              

		-- ������������ dL
		local dL=Fif-Fii

		-- ����������� ��� � ���������� �� ������������
		I = I + dt * (Uc - I * result.r - I * dL / dt) / Fii
		Uc = Uc - dt * I / config.c
		if Uc < 0 then Uc = 0 end --���� ����� ����������� ����

		if (config.mode > 0) and (result.vel < result.v_max) then I = 0 end
		
		if x > end_x and Force > -1 then I = 0 end -- ���� �������� �� ������� ������� � ���� ����� ���������
		if x < 0 then I = 0 end -- ���� �������� �����
	
		-- ���������� ������ � ������
		local res_item = {}
		res_item.i   = I
		res_item.f   = Force
		res_item.vel = result.vel
		res_item.x   = x*1000
		res_item.t   = result.t*1000000
		res_item.u   = Uc
		result.items[kc] = res_item
		kc = kc + 1
		
	until (I <= 0) or (result.vel < 0 )  -- ��������� ������, ���� �� ����� ���� 

	result.f_aver    = result.f_aver / (dt * kc)
	result.e_puli    = (result.m_puli * result.vel^2) / 2 
	result.e_puli0   = (result.m_puli * config.vel0^2) / 2
	result.e_c0      = (config.c * config.u^2) / 2
	result.e_c       = (config.c * Uc^2) / 2
	result.de_puli   = result.e_puli - result.e_puli0
	result.de_c      = result.e_c0 - result.e_c
	result.eff       = result.de_puli * 100 / result.de_c
	result.stop_date = date()

	-- ������� ������������� �����
	remove ("temp.fem")
	remove ("temp.ans")

	return result
end

----[ ������ ���������� ����������� � ���� ]---------------------------------------------------------------------------
function save_result_to_file(file_name, config, result)
	local handle = openfile(file_name, "a")
	function save(text) write (%handle, text .. "\n") end

	save("------------------------------------------------------------")
	save(format("������ ������� %s", result.start_date))
	save(format("����� �������  %s", result.stop_date))
	save(format("������ ������� %i", vers))
	save(format("����� �����, �����������  = %i", result.t*1000000))
	save(format("�������� �������,  ���    = %i", config.delta_t))
	save(format("������� ������������, ��� = %.1f", config.c*1000000))
	save(format("��������� ����������, �   = %.1f", config.u))
	save(format("����� �������������, ��   = %.3f", result.r))
	save(format("������� �������������, �� = %.3f", result.r_v))

	save("\n----- ������ ---------------------------------------------")
	save(format("������������� �������, �� = %.3f", result.r_kat))
	save(format("���������� ������         = %i", result.n))
	save(format("������� �������, ��       = %.2f", config.d_pr*1000))
	save(format("����� ����� �������, �    = %.1f", result.dl_provoda))

	save("\n----- ������� --------------------------------------------")
	save(format("����� �������, ��                            = %.1f", config.l_kat*1000))
	save(format("������� ������� �������, ��                  = %.1f", config.d_kat*1000))
	save(format("������������� ������� � �����. �������, ���� = %.1f", result.l*1000000))
	save(format("������� ����� �������� ��������������, ��    = %.1f", config.l_mag*1000))
	save(format("������� ������� �������� ��������������, ��  = %.1f", config.l_mag_y*1000))
	save(format("���������� ������� �������, ��               = %.1f", config.d_stv*1000))

	save("\n----- ���� --------------------------------------------")
	save(format("����� ���� ��� ��������, �       = %.2f", (result.m_puli-config.nagr)*1000))
	save(format("����� ����, ��                   = %.1f", config.l_puli*1000))
	save(format("������� ����, ��                 = %.1f", config.d_puli*1000))
	save(format("������� ��������� � ����, ��     = %.1f", config.l_otv*1000))
	save(format("������� ���������, ��            = %.2f", config.d_otv*1000))
	save(format("����� ��������, �                = %.2f", config.nagr*1000))
	save(format("����� ���� ������ � ���������, � = %.2f", result.m_puli*1000))
	save(format("��������� ������� ����, ��       = %.1f", config.l_sdv*1000))

	save("\n----- ������� ------------------------------------------")
	save(format("������� ���� ���������, ��         = %.1f", result.e_puli0))
	save(format("������� ����  ��������, ��         = %.1f", result.e_puli))
	save(format("���������� ������� ����, ��        = %.1f", result.de_puli))
	save(format("������� ������������ ���������, �� = %.1f", result.e_c0))
	save(format("������� ������������ ��������, ��  = %.1f", result.e_c))
	save(format("������ ������� ������������, ��    = %.1f", result.de_c))
	save(format("������� ����, �                    = %.1f", result.f_aver))
	save(format("���, %%                             = %.2f", result.eff))

	save("\n------ �������� ----------------------------------------")
	save(format("��������� �������� ����, �/�    = %.1f", config.vel0))
	save(format("�������� �������� ����, �/�     = %.1f", result.vel))
	save(format("������������ �������� ����, �/� = %.1f", result.v_max))

	save("\n------ Data of simulation -------------------------------")
	save("    ���(�)    ����(�)    ����(�) ����.(�/�)   ���.(��) ����.(���)")
	for i, item in result.items do
		save(
			format(
				"%10.1f %10.1f %10.2f %10.2f %10.3f %10.0f", 
				item.i, item.u, item.f, item.vel, item.x, item.t
			)		
		)
	end

	save("\n------ Data for export to Excel sheet --------------------")
	save("���� ���� (�)\t���������� (�)\t���� (�)\t�������� (�/�)\t������� x (��)\t����� (���)");
	for i, item in result.items do
		save(item.i .. "\t" .. item.u .. "\t" .. item.f .. "\t" .. item.vel .. "\t" .. item.x .. "\t" .. item.t)
	end
	closefile(handle)
end

----[ ����������, ��� ������ ������� ]---------------------------------------------------------------------------------

-- ������ ������
local conf_file_name=prompt("������� ��� ����� �����, ��� ���������� .txt") 
local config = read_config_file(conf_file_name .. ".txt")

-- ������ ������
create_project(config)

-- ���������� �������
local result = simulate(config)

-- ��������� ���������� � ����
local res_file_name = conf_file_name .. " V = " .. result.vel .. ".txt"
save_result_to_file(res_file_name, config, result)

-- ������� ���������� � �������
showconsole()
clearconsole()
print ("-----------------------------------")
print ("���������� ������ �������� � ����: " .. res_file_name)
