Public Class Form1


    Private Sub btnBuscarPuertos_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscarPuertos.Click
        Try
            cmbPuertos.Items.Clear()

            For Each puerto As String In My.Computer.Ports.SerialPortNames
                cmbPuertos.Items.Add(puerto)
                cmbPuertos.SelectedIndex() = 0
            Next

            If cmbPuertos.Items.Count = 0 Then
                MsgBox("No hay puertos", MsgBoxStyle.Critical)
            End If

        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Critical)
        End Try
    End Sub

    Private Sub btnConectar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConectar.Click
        Try
            With SPPuerto
                .BaudRate = 9600
                .Parity = IO.Ports.Parity.None
                .DataBits = 8
                .StopBits = 1
                .PortName = cmbPuertos.SelectedItem.ToString()
                .Open()

                If .IsOpen Then
                    lblEstado.Text = "Conectado"
                Else
                    MsgBox("Error de conexion", MsgBoxStyle.Critical)
                End If
            End With

        Catch ex As Exception
            MsgBox("Error de conexion", MsgBoxStyle.Critical)
        End Try
    End Sub

    Private Sub btnDesconectar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDesconectar.Click
        SPPuerto.Close()
        lblEstado.Text = "Desconectado"
    End Sub

    Private Sub SPPuerto_DataReceived(ByVal sender As Object, ByVal e As System.IO.Ports.SerialDataReceivedEventArgs) Handles SPPuerto.DataReceived
        Dim buffer As String = "Intervalo : " + "0.0" + " [seg]"
        'buffer = SPPuerto.ReadExisting()
        'txtRecibido.AppendText(buffer + vbNewLine)
        Dim Tiempo As Double
        Dim valor As Byte

        valor = SPPuerto.ReadByte()
        Tiempo += valor * 100
        valor = SPPuerto.ReadByte()
        Tiempo += valor * 10
        valor = SPPuerto.ReadByte()
        Tiempo += valor
        valor = SPPuerto.ReadByte()
        Tiempo += valor * 0.1
        valor = SPPuerto.ReadByte()
        Tiempo += valor * 0.01

        Tiempo = Math.Round(Tiempo, 2)

        Dim intervalo As Double = 0.0
        If Not lstTiempos.Items.Count = 0 Then
            intervalo = Math.Round((Tiempo - CDbl(lstTiempos.Items.Item(lstTiempos.Items.Count() - 1))), 2)
            buffer = "intervalo : " + intervalo.ToString + " [seg]" + vbNewLine
            lstTiempos.Items.Add(Tiempo)
            txtRecibido.AppendText(buffer)
        Else
            buffer = "INICIO( 0.0 seg)" + vbNewLine
            lstTiempos.Items.Add(0.0)
            txtRecibido.AppendText(buffer)
        End If





        Dim archivo As System.IO.StreamWriter

        Try

            archivo = My.Computer.FileSystem.OpenTextFileWriter(txtArchivo.Text() + ".txt", True) 'modo permite definir si se sobrescribe o se anexa



            archivo.WriteLine("marca = " + Tiempo.ToString() + "   ->  " + buffer)

            archivo.Close()

        Catch ex As Exception
            MsgBox("falta ubicacion y nombre del archivo", MsgBoxStyle.Critical)
        End Try

        Dim N As Decimal = intervalo * 100
        Math.Truncate(N)

        Dim a_enviar() As Byte
        ReDim a_enviar(3)

        'convierto el nuemero doulble en sus digitos para enviarlos
        a_enviar(0) = Int(N / 1000) 'Son las unidades de millar
        a_enviar(1) = Int((N - a_enviar(0) * 1000) / 100) 'Las centenas igual pero restandole los millares
        a_enviar(2) = Int((N - a_enviar(0) * 1000 - a_enviar(1) * 100) / 10) 'Las decenas igual pero restando los millares y centenas
        a_enviar(3) = Int((N - a_enviar(0) * 1000 - a_enviar(1) * 100 - a_enviar(2) * 10) / 1) 'Las unidades restandole todo lo anterior. No haria falta dividir por 1, pero por estetica lo dejo.

       
        SPPuerto.Write(a_enviar(0))
        SPPuerto.Write(a_enviar(1))
        SPPuerto.Write(a_enviar(2))
        SPPuerto.Write(a_enviar(3))

    End Sub

    
    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Control.CheckForIllegalCrossThreadCalls = False
    End Sub
End Class
