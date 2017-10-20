ALTER SESSION SET CURRENT_SCHEMA=Faculty;

declare
  l_cursor sys_refcursor;
  l_rows number;

begin
  dbms_output.enable(null);

  l_cursor := vivo.getFacultyMembers();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_members',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty names extracted');

  l_cursor := vivo.getFacultyMemberCountries();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_countries',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty countries extracted');

  l_cursor := vivo.getFacultyMemberRegions();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_regions',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty regions extracted');

  l_cursor := vivo.getFacultyMemberSubjectAreas();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_subject_areas',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty keywords extracted');

  l_cursor := vivo.getSubjectAreas();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_subject_areas',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' keywords extracted');

  /* The script section below only works on ozy
  */
  
  l_cursor := vivo.getDepartments();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_departments',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' departments extracted');

  l_cursor := vivo.getFacultyMemberPositions();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_positions',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member positions extracted');
  
  l_cursor := vivo.getInstitutions();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_institutions',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' institutions extracted');
  
  l_cursor := vivo.getFacultyMemberDegrees();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_degrees',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member degrees extracted');
  
  l_cursor := vivo.getResearchOverviews();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_research_overviews',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member research overviews extracted');
  
  l_cursor := vivo.getWebpageURLs();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_urls',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member URLs extracted');

  l_cursor := vivo.getAwardRecipients();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_awardrecipients',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member award recipients extracted');

  l_cursor := vivo.getAwards();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_awards',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member Awards extracted');

  l_cursor := vivo.getAwardOrgs();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_award_orgs',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member Award Orgs extracted');

  l_cursor := vivo.getVitaURLs();
  l_rows := unloader.run(p_cursor => l_cursor,
                         p_tname => NULL,
                         p_terminator => NULL,
                         p_dir => '/tmp',
                         p_filename => 'fis_faculty_member_vita',
                         p_ctl => 'NO',
                         p_header => 'YES');
  dbms_output.put_line(to_char(l_rows) || ' faculty member vita extracted');

end;

/

