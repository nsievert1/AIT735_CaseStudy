insert into USERS values('Nathan', 'A', 'Sievert', '703 Washington Ave', 
'Towson', 'MD', '21204', '1992-09-03', 'nsieve1@students.towson.edu', '3023549584', 'Collector', 1);
insert into USERS values('Emily', NULL, 'Sessa', '123 Main Street', 
'Baltimore', 'MD', '21202', '1993-09-20', 'test@test.com', '5489753681', 'Collector', 1);
insert into USERS values('Ryan', 'J', 'Clancy', '456 E. Oak Street', 
'Elkton', 'MD', '21921', '1993-04-15', 'test1@test1.com', '8745369518', 'Collector', 1);
insert into USERS values('Niraj', NULL, 'Raju', '34 York Road', 
'Baltimore', 'MD', '21206', '1993-12-15', 'niraj@gmail.com', '3023549587', 'Seller', 1);
insert into USERS values('Eric', 'J', 'Gardner', '7 Maple Lane', 
'New York', 'NY', '95874', '1993-11-19', 'ejgard@gmail.com', '3029874562', 'Seller', 0);



insert into ACCOUNT_TYPES values ('U', 'STANDARD USER')
insert into ACCOUNT_TYPES values ('S', 'SELLER')

insert into ALBUM_FORMATS values ('V', 'VINYL')
insert into ALBUM_FORMATS values ('CD', 'CD')
insert into ALBUM_FORMATS values ('C', 'Cassette')




insert into GENRES values ('Rock')
insert into GENRES values ('Rap/Hip-Hop')
insert into GENRES values ('Pop')
insert into GENRES values ('Indie/Alternative')
insert into GENRES values ('Metal')
insert into GENRES values ('Country/Folk')
insert into GENRES values ('Jazz')
insert into GENRES values ('Blues')
insert into GENRES values ('Classical')


insert into ALBUMS values ('Johnny Cash', 'I Walk The Line',
'Columbia', '1964', 'Country', 'Vinyl')
insert into ALBUMS values ('Bright Eyes', 'Cassadaga',
'Saddle Creek', '2007', 'Indie', 'Vinyl')
insert into ALBUMS values ('Johnny Cash', 'I Walk The Line',
'Columbia', '1964', 'Country', 'Vinyl')

insert into COLLECTIONS Values (1, 1, 'N', 15.00, '4', GETDATE())

insert into WANTLISTS values (1, 1, GETDATE())



exec sp_add_to_collection 16, 12, 'N', NULL, '3'
exec sp_add_user 'Anders', 'Lee', 'Van Winkle', '123 Main St.', 'Boston', 'MA',
'65789', '1992-01-23', 'test@test.com', '8888888888', 'COLLECTOR'
exec sp_add_to_wantlist 16, 11
exec sp_view_collection 15
exec sp_view_wantlist 15
exec sp_user_transactions 12, 1, 17