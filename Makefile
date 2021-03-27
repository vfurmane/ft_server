NAME		= ft_server
PORTS		= $(addprefix -p , 80:80)

all:		$(NAME)

$(NAME):	build run

build:
			docker build -t $(NAME) .

run:
			docker run $(PORTS) $(NAME)

clean:
			docker rm $(shell docker ps -alq -f 'label=image=ft_server')

fclean:		clean
			docker rmi $(NAME)

re:			fclean all

.PHONY:		all clean fclean re
