class BootstrapData < ActiveRecord::Migration
  def self.up
    execute "INSERT INTO event_types VALUES (1,'Rent','A rent transaction',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (2,'Buy Building','Building purchase',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (3,'Paypal Fund Buy','Game funds purchased through Paypal',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (4,'Level Sell Back','Player sold a level from a building they owned.',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (5,'Level Upgrade','Player bought a level upgrade.',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (6,'Daily Bread','The daily allowance from the game.',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (7,'Building Maintenance','Incremental or full building maintenance.',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (8,'Paid Rent','Not sure',NULL,NULL);"
    
    execute "INSERT INTO event_types VALUES (9,'Surprise 5000!','You found 5000!',NULL,NULL);"
    execute "INSERT INTO event_types VALUES (10,'Lotto!','Lotto!',NULL,NULL);"
    
    execute "INSERT INTO items VALUES (1,'Persuasive Duck','2005-09-19 09:03:53','2005-09-19 09:03:53');"
    execute "INSERT INTO items VALUES (2,'Hard Hat of Destruction','2005-09-19 09:03:53','2005-09-19 09:03:53');"
    
    execute "INSERT INTO property_types VALUES (1,'Two Star Hotel','Minimal comfort, but commands the second highest hotel price.',2300,0,'2005-07-23 22:45:00','2005-07-23 22:55:22',200,20,2000,20,2);"
    execute "INSERT INTO property_types VALUES (2,'Cheap Hotel','Cheapest of the hotels. Roaches stay for free.',1200,0,'2005-07-23 22:50:00','2005-07-23 22:55:46',100,15,1000,10,1);"
    execute "INSERT INTO property_types VALUES (3,'Three Star Hotel','What most people expect out of a hotel. Coordinated pastel scenes above color coordinated beds.',3600,0,'2005-07-23 22:53:00','2005-07-23 22:55:03',300,25,3000,30,3);"
    execute "INSERT INTO property_types VALUES (4,'Super Insane Hotel','Perfection all around, this hotel commands the highest prices at the highest levels.',33000,0,NULL,NULL,900,30,36000,40,4);"
    
    execute "INSERT INTO square_types VALUES (1,'Game Owned',0,'2005-07-23 22:56:00','2005-07-23 22:56:55');"
    execute "INSERT INTO square_types VALUES (2,'Player Owned',0,'2005-07-23 22:56:00','2005-07-23 22:57:07');"
    execute "INSERT INTO square_types VALUES (3,'Empty, Buyable',1,'2005-07-23 22:57:00','2005-07-23 22:57:19');"
    execute "INSERT INTO square_types VALUES (4,'Dead Space',0,'2005-07-23 22:57:00','2005-07-23 22:57:33');"
    execute "INSERT INTO square_types VALUES (5,'Quicky',0,NULL,NULL);"
  end

  def self.down
  end
end
