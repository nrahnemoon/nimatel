class Region < ActiveRecord::Base
  attr_accessible :name, :country_id, :prefix, :category, :registrar
  belongs_to :country

  CATEGORIES_CONVERSION = {
    "ADS" => 10,
    "AUD" => 20,
    "COU" => 30,
    "EMA" => 40,
    "FIX" => 50,
    "GTA" => 60,
    "IP" => 70,
    "ISP" => 80,
    "MOB" => 90,
    "NFX" => 100,
    "PAG" => 110,
    "PAY" => 120,
    "SAT" => 130,
    "TLX" => 140,
    "TTR" => 150,
    "VID" => 160,
    "VOG" => 170,
    "VOI" => 180,
    "VPN" => 190,
    "WLL" => 200,
    "XLR" => 210,
    "XNR" => 220,
    "XPN" => 230,
    "XPR" => 240,
    "XRC" => 250,
    "XSC" => 260,
    "XTF" => 270,
    "XTG" => 280
  }

  CATEGORIES = {
    10 => "DSL Internet",
    20 => "Audiotext",
    30 => "Default",
    40 => "Electronic/Fax Services",
    50 => "Landline",
    60 => "Global Title",
    70 => "VoIP",
    80 => "ISP",
    90 => "Mobile",
    100 => "National Geographic",
    110 => "Pager",
    120 => "Payphone",
    130 => "Satellite",
    140 => "Telex",
    150 => "Terrestrial Trunked Radio",
    160 => "Videotext",
    170 => "Landline Voicemail",
    180 => "Mobile Voicemail",
    190 => "VPN",
    200 => "Wireless Local Loop",
    210 => "Local Rate",
    220 => "National Rate",
    230 => "Universal Access",
    240 => "Premium Rate",
    250 => "Routing Code",
    260 => "Shared Cost",
    270 => "Freephone",
    280 => "Telegram"
  }

end
