   M S B A M L   `   `   `  ����L  HDarkSouls-Overlay, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null5clr-namespace:DarkSouls_OverlayDarkSouls_Overlay  5   	   "    DarkSouls_Overlay.MainWindow   5   	   W SPresentationCore, Version=9.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=9.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=9.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   1localclr-namespace:DarkSouls_Overlay     5   	   -   5          � Title$  Overlay��5	   	   $	��500��5
   	   $	��300��6    � WindowStyle$
 None=�5   	    � AllowsTransparency$
 True��5   	   
������  � Topmost$
 True��5   	    � ShowInTaskbar$ False��5   	    � 
ResizeMode$ NoResize=�5   	   .��5      � .+�5   
   � -   5         �Name$ loadingGrid��5      $y�Visible=�6$   .+�5      � -   5         �Name$ progressBar��5      $��Center=�6/   $��21��6L   $��	0,107,0,0q�6X   $	��Top=�6k   $	��180��6�   �� 5      -   5         ��Name$ loadingLabel��5      $��
Loading...��6*   $��Center=�6?   $��0,81,0,0q�6\   $	��Top=�6n   $��14(�6�   $��Arial Narrow)�6�   
�������6�   5      � 5    
   -   5        $ 
labelsGrid��5       $y�	Collapsed=�6#   .+�5"      �� -   5        $ serverStatusLabel��5"      $��Status: Not Started��5#      $
��Left=�5$      $��	10,10,0,0q�5%      $	��Top=�5&      $��18(�5'      $��Arial Narrow)�5(      
�������5)      �� 5,      -   5        $ playerNameLabel��5,      $��Player: Unknown��5-      $
��Left=�5.      $��	10,40,0,0q�5/      $	��Top=�50      $��18(�51      $��Arial Narrow)�52      
�������53      �� 56      -   5        $ 
deathLabel��56      $��Death: 0��57      $
��Left=�58      $��	10,70,0,0q�59      $	��Top=�5:      $��18(�5;      $��Arial Narrow)�5<      
�������5=      �� 5@      -	   5        $ locationLabel��5@      $��Unknown Location��5A      $
��Left=�5B      $��
10,100,0,0q�5C      $	��Top=�5D      $��18(�5E      $��Arial Narrow)�5F      
�������5G      �� 5J      -
   5        $ lastBossLabel��5J      $��Last Boss: Unknown��5K      $
��Left=�5L      $��
10,130,0,0q�5M      $	��Top=�5N      $��18(�5O      $��Arial Narrow)�5P      
�������5Q      �� 5S      .+�5T      �� -   5        	 ��Name$	 bossesListBox��5T      $
��Left=�5U      $	��Top=�5V      $��
10,140,0,0q�5W      $	��200��5X      
������ $��0q�5Z      $y�	Collapsed=�5[      $��15(�5\      $��Hidden=�5]      $��Hidden=�5^      ��5_      �� 5`      .R�5a      �� 5b      ��5d      �� 5e      
 �� 
TargetType"
 ��6    .�5f      ��  �� Property � �� �� Value
 ���� 6;   �� 5g       � ��$ 0q�6@   �� 5h       � ��
 �����6;   �� 5i       � ��$ 5q�68   �� 5j       � ��$
 Left=�6K   �� 5k       � ��$ Center=�6I   5l      5n      �� 5q      -   5        $ 	pageLabel��5q      $��<-- Page: 1/1 -->��5r      $��Center=�5s      $	��Top=�5t      $	��200��5u      $��0,10,0,0q�5v      $��14(�5w      $��Arial Narrow)�5x      
�������$y�	Collapsed=�5z      5{      5|      5}      5~      