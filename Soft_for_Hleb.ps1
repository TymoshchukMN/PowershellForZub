<#
    Автор:           TymoshchukMN
    Дата создания:      08.02.2022
    Дата изменения:     26.05.2022
    
    Лог изменений:  Добавлено динамическое изменение изображения в функции "CreatePointFlag"
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ================= определение разрешения экрана для создания динамических форм
[int16]$Width    = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
[int16]$Height   = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

# ================== получение адреса текущего каталога, для получения изображений
[string]$picPath = Get-Location

# ================== переменные используются в качетстве "флагов" для окраски кнопок
[bool]$global:point1 = $false
[bool]$global:point2 = $false
[bool]$global:point3 = $false
[bool]$global:point4 = $false


#region функции
# =================== функция изменения значения в поле "возраст ребенка" в меню 1
    function childAgeList_change{
        if ($childAgeList.SelectedItem -eq '0-6')
        {
            $localFractureList.Items.Clear()
            @('Через 1','Через 2') | ForEach-Object {[void] $localFractureList.Items.Add($_)}
        }elseif($childAgeList.SelectedItem -eq '7-12')
        {
            $localFractureList.Items.Clear()
            @('Через 1','Через 2','Через 3') | ForEach-Object {[void] $localFractureList.Items.Add($_)}
        }elseif($childAgeList.SelectedItem -eq '13-17')
        {
            $localFractureList.Items.Clear()
            @('Через 1','Через 2','Через 3','Через 4') | ForEach-Object {[void] $localFractureList.Items.Add($_)}
        }
    }

# ================== функция изменеия значения в поле локализация
    function localFractureList_change {
        if($childAgeList.SelectedItem -eq '0-6' -and $localFractureList.SelectedItem -eq 'Через 1')
        {
            $recommendOutputMenu2.text = "Выбран возраст '$($childAgeList.SelectedItem)' и локализация '$($localFractureList.SelectedItem)'"
            
            # ====== вызов функции на добавление фото на основную форму
            GetImageMainTab -picPath "$($picPath)\pc1.png"
            $Menu1.Controls | Where-Object {$_.text -like '*Точка*' -and $_.text -ne $($CurrentPoint) } | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6") } 
        
        }elseif($childAgeList.SelectedItem -eq '0-6' -and $localFractureList.SelectedItem -eq 'Через 2')
        {
            $recommendOutputMenu2.text = "Выбран возраст '$($childAgeList.SelectedItem)' и локализация '$($localFractureList.SelectedItem)'"
            
            # ====== вызов функции на добавление фото на основную форму
            GetImageMainTab -picPath "$($picPath)\pc4.png"
            $Menu1.Controls | Where-Object {$_.text -like '*Точка*' -and $_.text -ne $($CurrentPoint) } | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6") }

        }elseif($childAgeList.SelectedItem -eq '7-12' -and $localFractureList.SelectedItem -eq 'Через 1')
        {
           
            $recommendOutputMenu2.text = "Выбран возраст '$($childAgeList.SelectedItem)' и локализация '$($localFractureList.SelectedItem)'"
            
            # ====== вызов функции на добавление фото на основную форму
            GetImageMainTab -picPath "$($picPath)\IMG_7549.jpeg"
            $Menu1.Controls | Where-Object {$_.text -like '*Точка*' -and $_.text -ne $($CurrentPoint) } | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6") }

        }elseif($childAgeList.SelectedItem -eq '7-12' -and $localFractureList.SelectedItem -eq 'Через 2')
        {

            $recommendOutputMenu2.text = "Выбран возраст '$($childAgeList.SelectedItem)' и локализация '$($localFractureList.SelectedItem)'"
            
            # ====== вызов функции на добавление фото на основную форму
            GetImageMainTab -picPath "$($picPath)\pc3.png"
            $Menu1.Controls | Where-Object {$_.text -like '*Точка*' -and $_.text -ne $($CurrentPoint) } | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6") }

        }
    }

# ================== функция изменения цвета кнопок
    function changeColorBotton ([string]$CurrentPoint ) {
        $Menu1.Controls | Where-Object {$_.text -like '*Точка*' -and $_.text -ne $($CurrentPoint) } | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6") }
        $Menu1.Controls | Where-Object {$_.text -eq $CurrentPoint} | ForEach-Object {$_.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#7ed321")}
    }

# ================== функция получения изображения для передачи в меню 2
    function GetImageMainTab{
        param([string]$picPath)

        $image      =  [System.Drawing.Image]::Fromfile($(get-item "$($picPath)"))
        
        # ======= проверяем больше ли ширина фото ширины формы для фото
        if ($Pic1MainTab.Width -lt $image.Width)
        {
            # Находим на сколько % ширина изображения больше чем ширина формы, далее уменьшаем размеры формы на этот %
            [double]$precent    = [math]::Round((1-($image.Width - $Pic1MainTab.Width)/$image.Width),1)
            [int]$picWidth      = $image.Width * $precent
            [int]$picHeight     = $image.Height * $precent

        }elseif($Pic1MainTab.Height -lt $image.Height)
        {
            # Находим на сколько % высота изображения больше чем высота формы, далее уменьшаем размеры формы на этот %
            [double]$precent    = [math]::Round((1-($image.Height - $Pic1MainTab.Height)/$image.Height),1)
            [int]$picWidth      = $image.Width * $precent
            [int]$picHeight     = $image.Height * $precent

        }else
        {
            # === т.к. размер изображения меньше размера формы, ширина и высота картинки остаются неизменными
            [int]$picWidth      = $image.Width
            [int]$picHeight     = $image.Height
        }

        #[int]$w = $($image.width * 0.7)
        #[int]$h = $($image.height * 0.7)
        #$reimage    = [System.Drawing.Bitmap]::new($w,$h)
        $reimage    = [System.Drawing.Bitmap]::new($picWidth,$picHeight)
        $hg = [System.Drawing.Graphics]::FromImage($reimage)
        $hg.interpolationmode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $hg.drawimage($image,0,0,$picWidth,$picHeight)

        $Pic1MainTab.Image = $reimage
        return $Pic1MainTab
    }

# ================== функция создания флагов для Точка 1,2,3,4
    function CreatePointFlag ([string]$CurrentPoint){
        
        switch ($CurrentPoint) {
            'Точка 1' { 
                [bool]$global:point1 = $true
                [bool]$global:point2 = $false
                [bool]$global:point3 = $false
                [bool]$global:point4 = $false
                ;break }
            'Точка 2' { 
                [bool]$global:point1  = $false
                [bool]$global:point2 = $true
                [bool]$global:point3 = $false
                [bool]$global:point4 = $false
                ;break }
            'Точка 3' { 
                [bool]$global:point1 = $false
                [bool]$global:point2 = $false
                [bool]$global:point3 = $true
                [bool]$global:point4 = $false
                ;break }
            'Точка 4' { 
                [bool]$global:point1  = $false
                [bool]$global:point2 = $false
                [bool]$global:point3 = $false
                [bool]$global:point4 = $true
                ;break }
        }
    }

#endregion функции

#region основная форма
    # ================ создание основной формы
    $MainForm                           = New-Object system.Windows.Forms.Form
    $MainForm.ClientSize                = New-Object System.Drawing.Point($Width,$Height)
    $MainForm.text                      = "Программммммма"
    $MainForm.TopMost                   = $false
    $MainForm.BackColor                 = [System.Drawing.ColorTranslator]::FromHtml("#dad9d9")
    $MainForm.WindowState               = 'Maximized'
#endregion основная форма

#region создание меню 1 на основной вкладке
    # ================ оздание группы меню 1 на основной форме
    $Menu1                              = New-Object system.Windows.Forms.Groupbox
    $Menu1.text                         = "Меню 1"
    $Menu1.location                     = New-Object System.Drawing.Point(10,10)
    $Menu1.Size                         = New-Object System.Drawing.Size ($($MainForm.Size.Width-40),70)
    $Menu1.BackColor                    = [System.Drawing.ColorTranslator]::FromHtml("#f7f7f7")
    $Menu1.Anchor                       = 'left,right,top'
#endregion создание меню 1 на основной вкладке

#region возраст ребенка
    # =============== добавление выпадающего списка возраста ребенка
    $childAgeList                       = New-Object system.Windows.Forms.ComboBox
    $childAgeList.text                  = "Выберите возраст"
    $childAgeList.width                 = 120
    $childAgeList.height                = 20
    $childAgeList.location              = New-Object System.Drawing.Point(15,20)
    @('0-6','7-12','13-17') | ForEach-Object {[void] $childAgeList.Items.Add($_)}
#endregion возраст ребенка

#region локализация перелома 
    # =============== добавление выпадающего списка локализации перелома
    $localFractureList                  = New-Object system.Windows.Forms.ComboBox
    $localFractureList.text             = "Локализация"
    $localFractureList.width            = 350
    $localFractureList.height           = 20
    $localFractureList.location         = New-Object System.Drawing.Point(150,20)
#endregion region локализация перелома

#region создание кнопок на основной вкладке
    # =============== кнопка "Точка 1"
    $ButtonPoint1MainTab                = New-Object system.Windows.Forms.Button
    $ButtonPoint1MainTab.text           = "Точка 1"
    $ButtonPoint1MainTab.width          = 100
    $ButtonPoint1MainTab.height         = 23
    $ButtonPoint1MainTab.location       = New-Object System.Drawing.Point(715,10)
    $ButtonPoint1MainTab.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $ButtonPoint1MainTab.Anchor         = 'left,bottom'
    $ButtonPoint1MainTab.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6")

    # =============== кнопка "Точка 2"
    $ButtonPoint2MainTab                = New-Object system.Windows.Forms.Button
    $ButtonPoint2MainTab.text           = "Точка 2"
    $ButtonPoint2MainTab.width          = 100
    $ButtonPoint2MainTab.height         = 23
    $ButtonPoint2MainTab.location       = New-Object System.Drawing.Point(715,40)
    $ButtonPoint2MainTab.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $ButtonPoint2MainTab.Anchor         = 'left,bottom'
    $ButtonPoint2MainTab.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6")
    
    # =============== кнопка "Точка 3"
    $ButtonPoint3MainTab                = New-Object system.Windows.Forms.Button
    $ButtonPoint3MainTab.text           = "Точка 3"
    $ButtonPoint3MainTab.width          = 100
    $ButtonPoint3MainTab.height         = 23
    $ButtonPoint3MainTab.location       = New-Object System.Drawing.Point(835,10)
    $ButtonPoint3MainTab.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $ButtonPoint3MainTab.Anchor         = 'left,bottom'
    $ButtonPoint3MainTab.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6")
    
    # =============== кнопка "Точка 4"
    $ButtonPoint4MainTab                = New-Object system.Windows.Forms.Button
    $ButtonPoint4MainTab.text           = "Точка 4"
    $ButtonPoint4MainTab.width          = 100
    $ButtonPoint4MainTab.height         = 23
    $ButtonPoint4MainTab.location       = New-Object System.Drawing.Point(835,40)
    $ButtonPoint4MainTab.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $ButtonPoint4MainTab.Anchor         = 'left,bottom'
    $ButtonPoint4MainTab.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#ccc6c6")
    
    # =============== кнопка "отмена"
    $CancelBottonMainTab                = New-Object system.Windows.Forms.Button
    $CancelBottonMainTab.text           = "Отмена"
    $CancelBottonMainTab.width          = 100
    $CancelBottonMainTab.height         = 23
    $CancelBottonMainTab.location       = New-Object System.Drawing.Point(990,20)
    $CancelBottonMainTab.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $CancelBottonMainTab.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#f0b1b1")

#endregion создание кнопок на основной вкладке

#region зависимости между combobox 
    $childAgeList.Add_SelectedValueChanged({
        childAgeList_change                # вызов функции на заполнение поля "локализация перелома" на основе выбранного значения в поле "возраст ребенка"
    })

    $localFractureList.Add_SelectedValueChanged(
    {
        localFractureList_change
    })
#endregion зависимости между combobox

#region настройка меню2 на основной вкладке

    # ================ оздание группы меню 2 на основной форме
    $Menu2                              = New-Object system.Windows.Forms.Groupbox
    $Menu2.size                         = New-Object System.Drawing.Size($($MainForm.Size.Width-40),$($MainForm.Size.Height-$Menu1.Size.Height-70))
    $Menu2.text                         = "Меню 2"
    $Menu2.location                     = New-Object System.Drawing.Point(10,85)
    $Menu2.BackColor                    = [System.Drawing.ColorTranslator]::FromHtml("#f7f7f7")
    $Menu2.Anchor                       = 'left,right,top,bottom'

    # =========== добавление окна с рекомендациями в меню 2
    $recommendOutputMenu2               = New-Object system.Windows.Forms.TextBox
    $recommendOutputMenu2.multiline     = $true
    $recommendOutputMenu2.Size          = New-Object System.Drawing.Size($($Menu2.Size.Width-20),50)
    $recommendOutputMenu2.Anchor        = 'top,right,left'
    $recommendOutputMenu2.location      = New-Object System.Drawing.Point(10,20)
    $recommendOutputMenu2.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $recommendOutputMenu2.ScrollBars    = "Vertical"

    # ============ добавление фото в меню 2
    $Pic1MainTab                        = New-Object system.Windows.Forms.PictureBox
    $Pic1MainTab.Size                   = New-Object System.Drawing.Size($($Menu2.Size.Width-20),$($Menu2.Size.Height-$recommendOutputMenu2.Size.Height-35))
    $Pic1MainTab.SizeMode               = [System.Windows.Forms.PictureBoxSizeMode]::CenterImage
    $Pic1MainTab.Location               = New-Object System.Drawing.Point(10,80)
    $Pic1MainTab.Anchor                 = 'top,right,left,bottom'
    # ============ добавление фото на панель в меню 2

    # ============ добавление кнопок в меню 2
    $ButtonNextMenu2                    = New-Object system.Windows.Forms.Button
    $ButtonNextMenu2.text               = ">"
    $ButtonNextMenu2.width              = 45
    $ButtonNextMenu2.height             = 25
    $ButtonNextMenu2.location           = New-Object System.Drawing.Point($($MainForm.Width-160),$($MainForm.Height-115))
    $ButtonNextMenu2.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $ButtonNextMenu2.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#beb3b3")

    $ButtonBackMenu2                    = New-Object system.Windows.Forms.Button
    $ButtonBackMenu2.text               = "<"
    $ButtonBackMenu2.width              = 45
    $ButtonBackMenu2.height             = 25
    $ButtonBackMenu2.location           = New-Object System.Drawing.Point($($MainForm.Width-220),$($MainForm.Height-115))
    $ButtonBackMenu2.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $ButtonBackMenu2.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#beb3b3")
    
#endregion настройка меню2 на основной вкладке

#region действия кнопок на основной вкладке

    $ButtonPoint1MainTab.add_click(
    { # =========== проверяем заполнены ли поля "ЛОКАЛИЗАЦЯИ" и  "возраст"
        if([string]::IsNullOrEmpty($childAgeList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"Возраст ребенка`" не может быть пустым." , "Ошибка")
        }elseif([string]::IsNullOrEmpty($localFractureList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"локализации перелома`" не может быть пустым." , "Ошибка")
        }else
        {
            # ==== вызов функции на смену цвета вкладки
            CreatePointFlag -CurrentPoint  $ButtonPoint1MainTab.Text
            
            # ==== вызов функции на создание флага точки 
            changeColorBotton $ButtonPoint1MainTab.Text

            [int16]$global:point1PicCounter = 0

            GetImageMainTab -picPath "$($picPath)\point1_screen1.png"
            [array]$Global:picPointArray = @(
                "$($picPath)\point1_screen1.png",
                "$($picPath)\point1_screen2.png",
                "$($picPath)\point1_screen3.png",
                "$($picPath)\point1_screen4.png"
            )
        }
    })


    $ButtonPoint2MainTab.add_click({
        if([string]::IsNullOrEmpty($childAgeList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"Возраст ребенка`" не может быть пустым." , "Ошибка")
        }elseif([string]::IsNullOrEmpty($localFractureList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"локализации перелома`" не может быть пустым." , "Ошибка")
        }else
        {
            # ==== вызов функции на смену цвета вкладки
            changeColorBotton $ButtonPoint2MainTab.Text

            # ==== вызов функции на создание флага точки 
            CreatePointFlag -CurrentPoint  $ButtonPoint2MainTab.Text

            [int16]$point2PicCounter = 0
            GetImageMainTab -picPath "$($picPath)\point2_screen1.png"
            [array]$Global:picPointArray = @(
                "$($picPath)\point2_screen1.png",
                "$($picPath)\point2_screen2.png",
                "$($picPath)\point2_screen3.png",
                "$($picPath)\point2_screen4.png"
            )
        }
    })

    $ButtonPoint3MainTab.add_click({
        if([string]::IsNullOrEmpty($childAgeList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"Возраст ребенка`" не может быть пустым." , "Ошибка")
        }elseif([string]::IsNullOrEmpty($localFractureList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"локализации перелома`" не может быть пустым." , "Ошибка")
        }else
        {
            # ==== вызов функции на смену цвета вкладки
            changeColorBotton $ButtonPoint3MainTab.Text

            # ==== вызов функции на создание флага точки 
            CreatePointFlag -CurrentPoint  $ButtonPoint3MainTab.Text

            [int16]$point3PicCounter = 0
            GetImageMainTab -picPath "$($picPath)\point3_screen1.png"
            [array]$Global:picPointArray = @(
                "$($picPath)\point3_screen1.png",
                "$($picPath)\point3_screen2.png",
                "$($picPath)\point3_screen3.png",
                "$($picPath)\point3_screen4.png")
        }
       
    })

    $ButtonPoint4MainTab.add_click({
        if([string]::IsNullOrEmpty($childAgeList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"Возраст ребенка`" не может быть пустым." , "Ошибка")
        }elseif([string]::IsNullOrEmpty($localFractureList.SelectedItem))
        {
            [System.Windows.Forms.MessageBox]::Show("Поле `"локализации перелома`" не может быть пустым." , "Ошибка")
        }else
        {
            # ==== вызов функции на смену цвета вкладки
            changeColorBotton $ButtonPoint4MainTab.Text
            
            # ==== вызов функции на создание флага точки
            CreatePointFlag -CurrentPoint  $ButtonPoint4MainTab.Text

            [int16]$point4PicCounter = 0
            GetImageMainTab -picPath "$($picPath)\point4_screen1.png"
            [array]$Global:picPointArray = @(
                "$($picPath)\point4_screen1.png",
                "$($picPath)\point4_screen2.png",
                "$($picPath)\point4_screen3.png",
                "$($picPath)\point4_screen4.png")
        } 
    })

    # =========== действие кнопки "далее"
    $ButtonNextMenu2.add_click(
    {
        if($global:point1 -and ($global:point1PicCounter -le 2))
        {
            GetImageMainTab -picPath "$($global:picPointArray[++$global:point1PicCounter])"
        }elseif($global:point2 -and ($global:point2PicCounter -le 2))
        {        
            GetImageMainTab -picPath "$($global:picPointArray[++$global:point2PicCounter])"
        }elseif($global:point3 -and ($global:point3PicCounter -le 2))
        {
            GetImageMainTab -picPath "$($global:picPointArray[++$global:point3PicCounter])"
        }elseif($global:point4 -and ($global:point4PicCounter -le 2))
        {
            GetImageMainTab -picPath "$($global:picPointArray[++$global:point4PicCounter])"
        }
    })


    # =========== действие кнопки назад
    $ButtonBackMenu2.add_click(
    {    
        if($global:point1 -and ($global:point1PicCounter -gt 0))
        {    
            GetImageMainTab -picPath "$($global:picPointArray[--$global:point1PicCounter])"
        }elseif($global:point2 -and ($global:point2PicCounter -gt 0))
        {
            GetImageMainTab -picPath "$($global:picPointArray[--$global:point2PicCounter])"
        }elseif($global:point3 -and ($global:point3PicCounter -gt 0))
        {
            GetImageMainTab -picPath "$($global:picPointArray[--$global:point3PicCounter])"
        }elseif($global:point4 -and ($global:point4PicCounter -gt 0))
        {
            GetImageMainTab -picPath "$($global:picPointArray[--$global:point4PicCounter])"
        }
    })


    #region действие кнопки отмена в меню 1
        $CancelBottonMainTab.add_click({
            $MainForm.Close()
        })
    #endregion действие кнопки отмена в меню 1
#endregion действия кнопок на основной вкладке


#=====================================================
#=====================================================
$MainForm.Controls.AddRange(@($Menu1,$Menu2,$ButtonBackMenu2,$ButtonNextMenu2))
$Menu1.Controls.AddRange(@($childAgeList,$localFractureList,$ButtonPoint1MainTab,$ButtonPoint2MainTab,$ButtonPoint3MainTab,$ButtonPoint4MainTab,$CancelBottonMainTab))
$Menu2.Controls.AddRange(@($Pic1MainTab,$recommendOutputMenu2))

$MainForm.ShowDialog()