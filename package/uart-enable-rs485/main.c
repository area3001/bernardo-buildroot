#include <fcntl.h>
#include <termios.h>
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/serial.h>

#define TIOCSRS485  0x542F

void rs485_mode(int on)
{
  struct serial_rs485 rs485conf;
  memset(&rs485conf,0,sizeof(rs485conf));
  int fd = open ("/dev/ttyO2", O_RDWR);
  if (fd < 0) {
    /* Error handling. See errno. */
  }
  if(on)
  {
    rs485conf.flags |= SER_RS485_ENABLED;
    rs485conf.flags |= SER_RS485_RTS_ON_SEND;
    //rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
    rs485conf.delay_rts_before_send = 0x00000004;
    ioctl(fd, TIOCSRS485, &rs485conf);
  }
  else
  {
    rs485conf.flags &= ~SER_RS485_ENABLED;
    ioctl(fd, TIOCSRS485, &rs485conf);
  }
}

int main(int argc, char* argv[])
{
  rs485_mode(1);
}
